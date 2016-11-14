# -*- ruby -*-
#encoding: utf-8

require 'rmagick'

require 'strelka'
require 'strelka/httprequest/acceptparams'

require 'thingfish'
require 'thingfish/processor'


# Image processor plugin for Thingfish
class Thingfish::Processor::Image < Thingfish::Processor
	extend Loggability,
	       Configurability,
	       Strelka::MethodUtilities


	# Package version
	VERSION = '0.1.0'

	# Version control revision
	REVISION = %q$Revision$


	# Loggability API -- log to the :angelfish logger
	log_to :thingfish

	# Configurability API -- use the 'image_processor' section of the config
	config_key :image_processor


	# The default dimensions of thumbnails
	CONFIG_DEFAULTS = {
		thumbnail_dimensions: '100x100',
	}

	# An array of mediatypes to ignore, even though ImageMagick claims it groks them
	IGNORED_MIMETYPES = %w[
		application/octet-stream
		text/html
		text/plain
		text/x-server-parsed-html
	]


	##
	# The (maximum) dimensions of generated thumbnails
	singleton_attr_accessor :thumbnail_dimensions
	@thumbnail_dimensions = [ 100, 100 ]


	### Configurability API -- configure the processor with the :images section of
	### the config.
	def self::configure( config=nil )
		config = self.defaults.merge( config || {} )

		self.thumbnail_dimensions = config[:thumbnail_dimensions].split('x', 2).map( &:to_i )
	end



	#################################################################
	###	I N S T A N C E   M E T H O D S
	#################################################################

	### Set up a new Filter object
	def initialize( * ) # :notnew:
		super

		@supported_formats = find_supported_formats()
		@handled_types     = find_handled_types( @supported_formats )
		@generated_types   = find_generated_types( @supported_formats )
	end


	######
	public
	######

	# The Hash of formats and the operations they support.
	attr_reader :supported_formats

	# The mediatypes the plugin accepts in a request, as ThingFish::AcceptParam
	# objects
	attr_reader :handled_types

	# The mediatypes the plugin can generated in a response, as
	# ThingFish::AcceptParam objects
	attr_reader :generated_types


	### Returns +true+ if the given media +type+ is one the processor handles. Overridden so
	### the types can be used by the instance.
	def handled_type?( type )
		self.log.debug "Looking for handled type for: %p" % [ type ]
		result = self.handled_types.find {|handled_type| type =~ handled_type }
		self.log.debug "  found: %p" % [ result ]
		return result
	end
	alias_method :is_handled_type?, :handled_type?


	### Synchronous processor API -- extract metadata from uploaded images.
	def on_request( request )
		self.log.debug "Image-processing %p" % [ request ]
		image = case request.body
				when StringIO
					self.log.debug "  making a single image from a StringIO"
					Magick::Image.from_blob( request.body.read )
				else
					self.log.debug "  making a flattened image out of %p" % [ request.body.path ]
					list = Magick::ImageList.new( request.body.path )
					list.flatten_images
				end

		image = image.first if image.respond_to?( :first )
		self.log.debug "  image is: %p" % [ image ]
		metadata = self.extract_image_metadata( image )
		self.log.debug "  extracted image metadata: %p" % [ metadata ]
		request.add_metadata( metadata )

		self.log.debug "  going to generate a thumbnail..."
		self.generate_thumbnail( image, metadata['title'] ) do |thumbio, thumb_metadata|
			self.log.debug "  generated: %p (%p)" % [ thumbio, thumb_metadata ]
			request.add_related_resource( thumbio, thumb_metadata )
		end

		self.log.debug "  destroying the image to free up memory"
		image.destroy!
	end


	### Return a human-readable representation of the receiving object suitable for
	### debugging.
	def inspect
		return "#<%p:%#x %d supported image formats, %d readable, %d writable>" % [
			self.class,
			self.object_id * 2,
			self.supported_formats.size,
			self.handled_types.size,
			self.generated_types.size,
		]
	end


	#########
	protected
	#########

	### Extract metadata from the given +image+ (a Magick::Image object) and return it in
	### a Hash.
	def extract_image_metadata( image )
		metadata = {}

		metadata.merge!( self.get_regular_metadata(image) )
		metadata.merge!( self.get_exif_metadata(image) )

		return metadata
	end


	### Fetch regular image metadata as a Hash.
	def get_regular_metadata( image )
		return {
			'image:height'       => image.rows,
			'image:width'        => image.columns,
			'image:depth'        => image.depth,
			'image:density'      => image.density,
			'image:gamma'        => image.gamma,
			'image:bounding_box' => image.bounding_box.to_s,
		}
	end


	### Fetch exif metadata and return it as a Hash.
	def get_exif_metadata( image )
		exif_pairs = image.get_exif_by_entry
		exif_pairs.reject! {|name, val| name == 'unknown' || val.nil? }
		exif_pairs.collect! do |name, val|
			newname = name.gsub(/\B([A-Z])(?=[a-z])/) { '_' + $1 }.downcase
			[ "exif:#{newname}", val ]
		end
		return Hash[ exif_pairs ]
	end


	### Create a thumbnail from the given +image+ and return it in a string along with any
	### associated metadata.
	def generate_thumbnail( image, title )
		dimensions = self.class.thumbnail_dimensions
		self.log.debug "Making thumbnail of max dimensions: [%d X %d]" % dimensions
		thumb = image.resize_to_fit( *dimensions )
		imgdata = StringIO.new
		imgdata << thumb.to_blob {|img| img.format = 'JPG' }
		imgdata.rewind

		metadata = self.extract_image_metadata( thumb )
		metadata.merge!({
			format:       thumb.mime_type,
			relationship: 'thumbnail',
			title:        "Thumbnail of %s" % [ title || image.inspect ],
			extent:       imgdata.size,
		})

		self.log.debug "  made thumbnail for %p" % [ image ]
		yield( imgdata, metadata )

		thumb.destroy!
	end


	# A struct that can represent the support in the installed ImageMagick for
	# common operations. See Magick.formats for details.
	class MagickOperations

		### Create a new MagickOperations for the given +ext+, reading the
		### supported features of the format from +support_string+.
		def initialize( ext, support_string )
			@ext = ext
			@blob, @read, @write, @multi = support_string.split('')
		end

		##
		# Supported features
		attr_reader :ext, :blob, :read, :write, :multi


		### Return a human-readable description of the operations spec
		def to_s
			return [
				self.has_native_blob?	? "Blob" : nil,
				self.can_read?			? "Readable" : nil,
				self.can_write?			? "Writable" : nil,
				self.supports_multi?	? "Multi" : nil,
			].compact.join(',')
		end


		### Returns +true+ if the operation string indicates that ImageMagick has native blob
		### support for the associated type
		def has_native_blob?
			return (@blob == '*')
		end


		### Returns +true+ if the operation string indicates that ImageMagick has native blob
		### support for the associated type
		def can_read?
			return (@read == 'r')
		end


		### Returns +true+ if the operation string indicates that ImageMagick has native blob
		### support for the associated type
		def can_write?
			return (@write == 'w')
		end


		### Returns +true+ if the operation string indicates that ImageMagick has native blob
		### support for the associated type
		def supports_multi?
			return (@multi == '+')
		end

	end # class MagickOperations


	### Transform the installed ImageMagick's list of formats into AcceptParams
	### for easy comparison later.
	def find_supported_formats
		formats = {}
		raise "Config database doesn't have any mimetypes" if
			Mongrel2::Config.mimetypes.empty?

		# A hash of image formats and their properties. Each key in the returned
		# hash is the name of a supported image format. Each value is a string in
		# the form "BRWA". The details are in this table:
		#   B   is "*" if the format has native blob support, and "-" otherwise.
		#   R   is "r" if ×Magick can read the format, and "-" otherwise.
		#   W   is "w" if ×Magick can write the format, and "-" otherwise.
		#   A   is "+" if the format supports multi-image files, and "-" otherwise.
		Magick.formats.each do |ext,support|
			ext = ".#{ext.downcase}"
			self.log.debug "Looking for mediatype for ext: %s (%p)" % [ ext, support ]

			mimetype = Mongrel2::Config.mimetypes[ ext ] or next
			self.log.debug "  mimetype is: %p" % [ mimetype ]
			next if IGNORED_MIMETYPES.include?( mimetype )

			operations = MagickOperations.new( ext, support )
			self.log.debug "  registering image format %s (%s)" % [ mimetype, operations ]
			formats[ mimetype ] = operations
		end

		self.log.debug "Registered mimetype mapping for %d of %d supported image types" %
			[ formats.keys.length, Magick.formats.length ]
		return formats
	end


	### Return Strelka::HTTPRequest::MediaType objects for the formats that the
	### processor is capable of reading.
	def find_handled_types( supported_formats )
		return supported_formats.
			select {|type, op| op.can_read? }.
			collect {|type, op| Strelka::HTTPRequest::MediaType.parse(type) }
	end


	### Return an Array of Strelka::HTTPRequest::MediaType objects for the
	### formats that the processor is capable of writing.
	def find_generated_types( supported_formats )
		return supported_formats.
			select {|type, op| op.can_write? }.
			collect {|type, op| Strelka::HTTPRequest::MediaType.parse(type) }
	end

end # class ThingFish::Processor::Image


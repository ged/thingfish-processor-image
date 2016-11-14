#!/usr/bin/env ruby

require_relative '../../spec_helper'

require 'rspec'
require 'strelka'
require 'strelka/httprequest/metadata'
require 'thingfish/processor/image'



describe Thingfish::Processor::Image, :db do

	before( :all ) do
		Strelka::HTTPRequest.class_eval { include Strelka::HTTPRequest::Metadata }
	end


	let( :processor ) { Thingfish::Processor.create(:image) }
	let( :factory ) do
		Mongrel2::RequestFactory.new(
			:route => '/',
			:headers => {:accept => '*/*'})
	end


	it "extracts image metadata from uploaded images" do
		req = factory.post( '/tf', fixture_data('skunks.jpg'), 'Content-type' => 'image/jpeg' )

		processor.process_request( req )

		expect( req.metadata ).to include( "image:bounding_box" => "width=640, height=480, x=0, y=0" )
	end


	it "extracts exif metadata from uploaded images" do
		req = factory.post( '/tf', fixture_data('skunks.jpg'), 'Content-type' => 'image/jpeg' )

		processor.process_request( req )

		expect( req.metadata ).to include( "exif:software" => "Pixelmator 3.1" )
	end


	it "creates a thumbnail of uploaded images" do
		req = factory.post( '/tf', fixture_data('skunks.jpg'), 'Content-type' => 'image/jpeg' )

		processor.process_request( req )

		expect( req.related_resources.size ).to eq( 1 )
		expect( req.related_resources.keys.first ).to be_a( StringIO )
		expect( req.related_resources.values.first ).
			to include( 'image:height' => 75, 'image:width' => 100 )
	end


	it "extracts IPTC metadata from uploaded images"

end

# vim: set nosta noet ts=4 sw=4 ft=rspec:

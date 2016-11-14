# -*- ruby -*-
#encoding: utf-8

require 'simplecov' if ENV['COVERAGE']

require 'rspec'

require 'mongrel2'
require 'mongrel2/testing'

require 'thingfish'
require 'thingfish/spechelpers'

require 'loggability/spechelpers'

require 'thingfish/processor/image'


module Thingfish::Processor::Image::SpecHelpers

	FIXTURE_DIR = Pathname( __FILE__ ).dirname + 'data'


	### Load and return the data from the fixture with the specified +filename+.
	def fixture_data( filename )
		fixture = FIXTURE_DIR + filename
		return fixture.open( 'r', encoding: 'binary' )
	end

end



### Mock with RSpec
RSpec.configure do |config|
	config.run_all_when_everything_filtered = true
	config.filter_run :focus
	config.order = 'random'
	config.mock_with( :rspec ) do |mock|
		mock.syntax = :expect
	end

	config.include( Mongrel2::SpecHelpers )
	config.include( Thingfish::SpecHelpers )
	config.include( Loggability::SpecHelpers )
	config.include( Thingfish::Processor::Image::SpecHelpers )
end




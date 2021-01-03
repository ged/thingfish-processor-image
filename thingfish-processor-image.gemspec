# -*- encoding: utf-8 -*-
# stub: thingfish-processor-image 0.3.0.pre.20210103001529 ruby lib

Gem::Specification.new do |s|
  s.name = "thingfish-processor-image".freeze
  s.version = "0.3.0.pre.20210103001529"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "changelog_uri" => "http://deveiate.org/code/thingfish-processor-image/History_md.html", "documentation_uri" => "http://deveiate.org/code/thingfish-processor-image", "homepage_uri" => "http://deveiate.org/projects/Thingfish-Processor-Image", "source_uri" => "http://bitbucket.org/ged/Thingfish-Processor-Image" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Michael Granger".freeze]
  s.date = "2021-01-03"
  s.description = "This is a basic image-processor plugin for the Thingfish digital asset manager. It extracts image-related metadata from uploaded media files, and generates one or more thumbnail images as related resources.".freeze
  s.email = ["ged@FaerieMUD.org".freeze]
  s.files = [".document".freeze, ".editorconfig".freeze, ".rdoc_options".freeze, ".simplecov".freeze, "History.md".freeze, "LICENSE.txt".freeze, "Manifest.txt".freeze, "README.md".freeze, "Rakefile".freeze, "lib/thingfish/processor/image.rb".freeze, "spec/data/skunks.jpg".freeze, "spec/spec_helper.rb".freeze, "spec/thingfish/processor/image_spec.rb".freeze]
  s.homepage = "http://deveiate.org/projects/Thingfish-Processor-Image".freeze
  s.licenses = ["BSD-3-Clause".freeze]
  s.rubygems_version = "3.2.3".freeze
  s.summary = "This is a basic image-processor plugin for the Thingfish digital asset manager.".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<rmagick>.freeze, ["~> 4.1"])
    s.add_runtime_dependency(%q<thingfish>.freeze, ["~> 0.8"])
    s.add_development_dependency(%q<rake-deveiate>.freeze, ["~> 0.17"])
    s.add_development_dependency(%q<rdoc-generator-fivefish>.freeze, ["~> 0.4"])
  else
    s.add_dependency(%q<rmagick>.freeze, ["~> 4.1"])
    s.add_dependency(%q<thingfish>.freeze, ["~> 0.8"])
    s.add_dependency(%q<rake-deveiate>.freeze, ["~> 0.17"])
    s.add_dependency(%q<rdoc-generator-fivefish>.freeze, ["~> 0.4"])
  end
end

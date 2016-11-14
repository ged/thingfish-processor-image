# -*- encoding: utf-8 -*-
# stub: thingfish-processor-image 0.2.pre20161114102348 ruby lib

Gem::Specification.new do |s|
  s.name = "thingfish-processor-image"
  s.version = "0.2.pre20161114102348"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Michael Granger"]
  s.cert_chain = ["certs/ged.pem"]
  s.date = "2016-11-14"
  s.description = "This is a basic image-processor plugin for the Thingfish digital asset manager.\nIt extracts image-related metadata from uploaded media files, and generates one\nor more thumbnail images as related resources."
  s.email = ["ged@FaerieMUD.org"]
  s.extra_rdoc_files = ["History.md", "LICENSE.txt", "Manifest.txt", "README.md", "History.md", "README.md"]
  s.files = [".document", ".editorconfig", ".rdoc_options", ".simplecov", "ChangeLog", "History.md", "LICENSE.txt", "Manifest.txt", "README.md", "Rakefile", "lib/thingfish/processor/image.rb", "spec/data/skunks.jpg", "spec/spec_helper.rb", "spec/thingfish/processor/image_spec.rb"]
  s.homepage = "https://bitbucket.org/ged/thingfish-processor-image"
  s.licenses = ["BSD-3-Clause"]
  s.rdoc_options = ["--main", "README.md"]
  s.required_ruby_version = Gem::Requirement.new(">= 2.3.1")
  s.rubygems_version = "2.5.1"
  s.summary = "This is a basic image-processor plugin for the Thingfish digital asset manager"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mongrel2>, [">= 0.46"])
      s.add_runtime_dependency(%q<thingfish>, ["~> 0.5"])
      s.add_runtime_dependency(%q<loggability>, ["~> 0.11"])
      s.add_runtime_dependency(%q<rmagick>, ["~> 2.16"])
      s.add_development_dependency(%q<hoe-mercurial>, ["~> 1.4"])
      s.add_development_dependency(%q<hoe-deveiate>, ["~> 0.8"])
      s.add_development_dependency(%q<hoe-highline>, ["~> 0.2"])
      s.add_development_dependency(%q<simplecov>, ["~> 0.7"])
      s.add_development_dependency(%q<rdoc-generator-fivefish>, ["~> 0.1"])
      s.add_development_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_development_dependency(%q<hoe>, ["~> 3.15"])
    else
      s.add_dependency(%q<mongrel2>, [">= 0.46"])
      s.add_dependency(%q<thingfish>, ["~> 0.5"])
      s.add_dependency(%q<loggability>, ["~> 0.11"])
      s.add_dependency(%q<rmagick>, ["~> 2.16"])
      s.add_dependency(%q<hoe-mercurial>, ["~> 1.4"])
      s.add_dependency(%q<hoe-deveiate>, ["~> 0.8"])
      s.add_dependency(%q<hoe-highline>, ["~> 0.2"])
      s.add_dependency(%q<simplecov>, ["~> 0.7"])
      s.add_dependency(%q<rdoc-generator-fivefish>, ["~> 0.1"])
      s.add_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_dependency(%q<hoe>, ["~> 3.15"])
    end
  else
    s.add_dependency(%q<mongrel2>, [">= 0.46"])
    s.add_dependency(%q<thingfish>, ["~> 0.5"])
    s.add_dependency(%q<loggability>, ["~> 0.11"])
    s.add_dependency(%q<rmagick>, ["~> 2.16"])
    s.add_dependency(%q<hoe-mercurial>, ["~> 1.4"])
    s.add_dependency(%q<hoe-deveiate>, ["~> 0.8"])
    s.add_dependency(%q<hoe-highline>, ["~> 0.2"])
    s.add_dependency(%q<simplecov>, ["~> 0.7"])
    s.add_dependency(%q<rdoc-generator-fivefish>, ["~> 0.1"])
    s.add_dependency(%q<rdoc>, ["~> 4.0"])
    s.add_dependency(%q<hoe>, ["~> 3.15"])
  end
end

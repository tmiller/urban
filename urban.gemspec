# -*- encoding: utf-8 -*-
# stub: urban 2.0.1.20160106192934 ruby lib

Gem::Specification.new do |s|
  s.name = "urban"
  s.version = "2.0.1.20160106192934"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Tom Miller"]
  s.date = "2016-01-07"
  s.description = "Urban is a command line utility with an API to query definitions from Urban\nDictionary."
  s.email = ["jackerran@gmail.com"]
  s.executables = ["urban"]
  s.extra_rdoc_files = ["History.rdoc", "Manifest.txt", "README.rdoc"]
  s.files = [".travis.yml", "History.rdoc", "LICENSE", "Manifest.txt", "README.rdoc", "Rakefile", "bin/urban", "lib/urban.rb", "lib/urban/cli.rb", "lib/urban/dictionary.rb", "lib/urban/web.rb", "script/test", "test/fixtures/impromptu.html", "test/fixtures/missing.html", "test/fixtures/screens/definition.txt", "test/fixtures/screens/definition_with_url.txt", "test/fixtures/screens/definitions.txt", "test/fixtures/screens/help.txt", "test/fixtures/screens/invalid_option_error.txt", "test/fixtures/screens/missing_phrase_error.txt", "test/fixtures/screens/no_internet_error.txt", "test/test_helper.rb", "test/urban/cli_test.rb", "test/urban/dictionary_test.rb", "test/urban/web_test.rb"]
  s.homepage = "http://github.com/tmiller/urban"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--main", "README.rdoc"]
  s.rubygems_version = "2.2.2"
  s.summary = "Urban is a command line utility with an API to query definitions from Urban Dictionary."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, ["~> 1.5.0"])
      s.add_development_dependency(%q<minitest>, ["~> 5.8"])
      s.add_development_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_development_dependency(%q<hoe>, ["~> 3.14"])
      s.add_development_dependency(%q<hoe-gemspec>, ["~> 1.0"])
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
    else
      s.add_dependency(%q<nokogiri>, ["~> 1.5.0"])
      s.add_dependency(%q<minitest>, ["~> 5.8"])
      s.add_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_dependency(%q<hoe>, ["~> 3.14"])
      s.add_dependency(%q<hoe-gemspec>, ["~> 1.0"])
      s.add_dependency(%q<rake>, ["~> 10.0"])
    end
  else
    s.add_dependency(%q<nokogiri>, ["~> 1.5.0"])
    s.add_dependency(%q<minitest>, ["~> 5.8"])
    s.add_dependency(%q<rdoc>, ["~> 4.0"])
    s.add_dependency(%q<hoe>, ["~> 3.14"])
    s.add_dependency(%q<hoe-gemspec>, ["~> 1.0"])
    s.add_dependency(%q<rake>, ["~> 10.0"])
  end
end

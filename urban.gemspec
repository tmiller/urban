# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'urban/version'

Gem::Specification.new do |s|
  s.name        = 'urban'
  s.version     = Urban::VERSION
  s.authors     = ['Tom Miller']
  s.email       = ['jackerran@gmail.com']
  s.homepage    = 'https://github.com/tmiller/urban'
  s.summary     = %q{A scraper for Urban Dictionary}
  s.description = %q{A scraper for urban dictionary. It comes with a command line tool to get random definitions from urbandictionary.com.}

  s.rubyforge_project = 'urban'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'nokogiri'
  s.add_dependency 'i18n'
  s.add_dependency 'activesupport'
  s.add_development_dependency 'ruby-debug19'
end

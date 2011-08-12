# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'urban/version'

Gem::Specification.new do |s|
  s.name        = 'urban'
  s.version     = Urban::VERSION
  s.authors     = ['Tom Miller']
  s.email       = ['jackerran@gmail.com']
  s.homepage    = ''
  s.summary     = %q{A scraper for Urban Dictionary}
  s.description = %q{A scraper for urban dictionary. It comes with a command line tool to get random definitions from urbandictionary.com.}

  s.rubyforge_project = 'urban'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_development_dependency 'nokogiri'
  s.add_development_dependency 'activesupport'
end

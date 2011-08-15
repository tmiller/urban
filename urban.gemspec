# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'urban/version'

Gem::Specification.new do |s|
  s.name        = 'urban'
  s.version     = Urban::VERSION
  s.authors     = ['Tom Miller']
  s.email       = ['jackerran@gmail.com']
  s.homepage    = 'https://github.com/tmiller/urban'
  s.summary     = %q{A command line tool to output a random Urban Dictionary entry}
  s.description = %q{Currently only a beta command line tool that outputs a random urban dictionary entry. In
                     the future there are plans to add other features to the tool such as search
                     and word of the day. There will also be an api to use in your projects.}

  s.rubyforge_project = 'urban'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'nokogiri'
  s.add_development_dependency 'ruby-debug19'
end

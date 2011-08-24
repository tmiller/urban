# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'urban/version'

Gem::Specification.new do |s|
  s.name        = 'urban'
  s.version     = Urban::VERSION
  s.authors     = ['Thomas Miller']
  s.email       = ['jackerran@gmail.com']
  s.licenses    = ['MIT']
  s.homepage    = 'https://github.com/tmiller/urban'
  s.summary     = %q{A command line tool that interfaces with Urban Dictionary.}
  s.description = %q{Urban is a command line tool that allows you to look up definitions
                     or pull a random definition from Urban Dictionary.}

  s.rubyforge_project = 'urban'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'nokogiri', '~> 1.5.0'
  s.add_development_dependency 'ruby-debug19', '~> 0.11.6'
end

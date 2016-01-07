# -*- ruby -*-
require "rubygems"
require "hoe"

Hoe.plugin :minitest
Hoe.plugin :gemspec
Hoe.plugin :git

Hoe.spec "urban" do
  self.readme_file = "README.rdoc"
  self.history_file = "History.rdoc"

  license "MIT"
  developer("Tom Miller", "jackerran@gmail.com")

  dependency 'nokogiri',    '~> 1.5.0'

  dependency 'hoe',         '~> 3.14', :development
  dependency 'hoe-gemspec', '~> 1.0',  :development
  dependency 'rake',        '~> 10.0', :development
  dependency 'minitest',    '~> 5.0',  :development
end

# vim: syntax=ruby

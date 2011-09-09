require 'rubygems'
require 'bundler/gem_helper'
Bundler::GemHelper.install_tasks


task :default => :test

require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
  t.warning = true
end

Rake::TestTask.new do |t|
  t.name = 'test:cli'
  t.libs << "test"
  t.test_files = FileList['test/**/cli_test.rb']
  t.verbose = true
  t.warning = true
end

Rake::TestTask.new do |t|
  t.name = 'test:dictionary'
  t.libs << "test"
  t.test_files = FileList['test/**/dictionary_test.rb']
  t.verbose = true
  t.warning = true
end

Rake::TestTask.new do |t|
  t.name = 'test:web'
  t.libs << "test"
  t.test_files = FileList['test/**/web_test.rb']
  t.verbose = true
  t.warning = true
end

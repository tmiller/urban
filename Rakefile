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
  t.name = 'color'
  t.libs << "test"
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
  t.warning = true
  t.ruby_opts = ['-rminitest/pride']
end


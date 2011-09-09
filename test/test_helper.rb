$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))

require 'rubygems'
gem 'minitest' if RUBY_VERSION > '1.9'
require 'minitest/autorun'
require 'urban'
require 'urban/cli'
require 'minitest/stop_light'

TEST_ENTRY = Urban::Dictionary::Entry.new(:success, 'impromptu',
  [ 'Something that is made up on the spot and given little time to gather and present. Usually referring to speeches that are given only a few minutes to prepare for.',
    'On the spot',
    'Something that is made up on the spot.  Can also mean a speech that was made with little or no preparation.' ],
    'http://www.urbandictionary.com/define.php?term=impromptu')

TEST_ENTRY_NOT_FOUND = Urban::Dictionary::Entry.new( :not_found, nil, nil, nil)

def load_file(filename)
  IO.read(File.expand_path("../data/#{filename}", __FILE__))
end

module Stub
  def stub(name, &block)
    singleton_class = class << self; self; end
    singleton_class.send(:define_method, name, &block)
  end
end

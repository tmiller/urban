$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))

require 'rubygems'
require 'minitest/autorun'
require 'urban'
require 'urban/cli'

TEST_PHRASE = OpenStruct.new({
  :word => 'impromptu',
  :definitions => [
    'Something that is made up on the spot and given little time to gather and present. Usually referring to speeches that are given only a few minutes to prepare for.',
    'On the spot',
    'Something that is made up on the spot.  Can also mean a speech that was made with little or no preparation.'
]})

def load_file(filename)
  IO.read(File.expand_path("../data/#{filename}", __FILE__))
end

['refute', 'assert'].each do |action|
  eval <<-EOM
    def #{action}_cli_prints(matches, &block)
      out, err = capture_io(&block)
      [*matches].each { |match| #{action}_match(match, out) }
    end
  EOM
end

module Stub
  def stub(name, &block)
    self.class.send(:remove_method, name) if respond_to?(name)
    self.class.send(:define_method, name, &block)
  end
end

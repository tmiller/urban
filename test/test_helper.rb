$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))

require 'rubygems'
gem 'minitest' if RUBY_VERSION > '1.9'
require 'minitest/autorun'
require 'urban'
require 'urban/cli'
require 'minitest/stop_light'
require 'ostruct'

class Urban::TestCase < MiniTest::Unit::TestCase

  def load_fixture(filename)
    IO.read(File.expand_path("../fixtures/#{filename}", __FILE__))
  end

  def empty_entry
    @empty_entry ||= Urban::Dictionary::Entry.new('gubble', nil, nil)
  end

  def test_entry
    @test_entry ||= Urban::Dictionary::Entry.new(
      "impromptu",
      [
        "Something that is made up on the spot and given little time to " +
          "gather and present. Usually referring to speeches that are given " +
          "only a few minutes to prepare for.",
        "On the spot",
        "Something that is made up on the spot.  " +
          "Can also mean a speech that was made with little or no preparation."
      ],
      "http://www.urbandictionary.com/define.php?term=impromptu"
    )
  end

end


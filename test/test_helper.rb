$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))

require "rubygems"
require "minitest/autorun"
require "minitest/pride"
require "urban"
require "ostruct"

class Urban::Test < Minitest::Test

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


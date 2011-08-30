require 'test_helper'

class DictionaryTest < MiniTest::Unit::TestCase

  def setup
    @dictionary = Urban::Dictionary.new
    @web_service = MiniTest::Mock.new
    @expected = {
      word: 'impromptu',
      definitions: [
        'Something that is made up on the spot and given little time to gather and present. Usually referring to speeches that are given only a few minutes to prepare for.',
        'On the spot',
        'Something that is made up on the spot.  Can also mean a speech that was made with little or no preparation.'
      ]
    }
  end

  def test_dictionary_calls_random
    @web_service.expect(:query, load_file('impromptu.html') ,[:random])
    @dictionary.web_service = @web_service
    assert_equal(@expected, @dictionary.random)
    @web_service.verify
  end

  def test_dictionary_calls_define
    @web_service.expect(:query, load_file('impromptu.html'), [:define, 'impromptu'])
    @dictionary.web_service = @web_service
    assert_equal(@expected, @dictionary.define('impromptu'))
    @web_service.verify
  end
end

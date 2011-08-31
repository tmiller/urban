require 'test_helper'

class DictionaryTest < MiniTest::Unit::TestCase

  def setup
    @dictionary = (Urban::Dictionary.new).extend Stub
  end

  def test_dictionary_calls_random
    web_service = MiniTest::Mock.new
    @dictionary.stub(:web_service) do
      web_service.expect(:query, load_file('impromptu.html') ,[:random])
    end
    assert_equal(TEST_PHRASE, @dictionary.random)
    web_service.verify
  end

  def test_dictionary_calls_define
    web_service = MiniTest::Mock.new
    @dictionary.stub(:web_service) do
      web_service.expect(:query, load_file('impromptu.html'), [:define, 'impromptu'])
    end
    assert_equal(TEST_PHRASE, @dictionary.define('impromptu'))
    web_service.verify
  end
end

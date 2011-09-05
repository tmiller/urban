require 'test_helper'

class DictionaryTest < MiniTest::Unit::TestCase

  def setup
    @web_service = MiniTest::Mock.new
    @dictionary = Urban::Dictionary
  end

  def test_process_extracts_elements_from_html
   entry = @dictionary.send(:process, load_file('impromptu.html'))
   assert_equal(TEST_ENTRY, entry)
  end

  def test_dictionary_calls_random
    @dictionary.web_service = @web_service.expect(:random, load_file('impromptu.html'))
    assert_equal(TEST_ENTRY, @dictionary.random)
    @web_service.verify
  end

  def test_dictionary_calls_search
   @dictionary.web_service = @web_service.expect(:search, load_file('impromptu.html'), ['impromptu'])
   assert_equal(TEST_ENTRY, @dictionary.search('impromptu'))
   @web_service.verify
  end
end

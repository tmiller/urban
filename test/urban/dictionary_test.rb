require 'test_helper'

class DictionaryTest < Urban::TestCase

  def setup
    @web_service = MiniTest::Mock.new
    @dictionary = Urban::Dictionary

    @response = OpenStruct.new
    @response.url = 'http://www.urbandictionary.com/define.php?term=impromptu'
    @response.stream = load_fixture 'impromptu.html'
  end

  def test_process_extracts_elements_from_html
    entry = @dictionary.send(:process, @response )
    assert_equal(test_entry, entry)
  end

  def test_dictionary_calls_random
    @dictionary.web_service = @web_service.expect(:random, @response)
    assert_equal(test_entry, @dictionary.random)
    @web_service.verify
  end

  def test_dictionary_calls_search
   @dictionary.web_service = @web_service.expect(:search, @response, ['impromptu'])
   assert_equal(test_entry, @dictionary.search('impromptu'))
   @web_service.verify
  end

  def test_dictionary_returns_empty_for_missing_phrases
    @response.stream = load_fixture 'missing.html'
    @dictionary.web_service = @web_service.expect(:search, @response, ['gubble'])
    assert_equal(empty_entry, @dictionary.search('gubble'))
    @web_service.verify
  end
end

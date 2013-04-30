require "test_helper"
require "urban/dictionary"

class DictionaryTest < Urban::Test

  attr_accessor :web_service, :dictionary, :response

  def setup
    self.web_service = MiniTest::Mock.new
    self.dictionary = Urban::Dictionary.new

    dictionary.web_service = web_service

    self.response = OpenStruct.new(
      :url => "http://www.urbandictionary.com/define.php?term=impromptu",
      :stream => load_fixture("impromptu.html")
    )
  end

  def test_process_extracts_elements_from_html
    entry = dictionary.send(:process, response )
    assert_equal(test_entry, entry)
  end

  def test_dictionary_calls_random
    web_service.expect(:random, response)

    assert_equal(test_entry, dictionary.random)
    web_service.verify
  end

  def test_dictionary_calls_search
   web_service.expect(:search, response, ['impromptu'])

   assert_equal(test_entry, dictionary.search('impromptu'))
   web_service.verify
  end

  def test_dictionary_returns_empty_for_missing_phrases
    response.stream = load_fixture 'missing.html'
    web_service.expect(:search, response, ['gubble'])

    assert_equal(empty_entry, dictionary.search('gubble'))
    web_service.verify
  end

end

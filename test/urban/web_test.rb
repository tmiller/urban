require 'test_helper'

class WebTest < MiniTest::Unit::TestCase

  def setup
    @web_module = (Object.new).extend(Urban::Web).extend(Stub)
  end

  class WebFetchTest < WebTest
    def setup
      super
      @web_module.stub(:open) { |arg| arg }
    end

    def test_fetch_with_no_params
      expected = 'http://www.urbandictionary.com/test.php'
      actual = @web_module.fetch('test.php')
      assert_equal(expected, actual)
    end

    def test_fetch_with_params
      expected = /http:\/\/www\.urbandictionary\.com\/test\.php\?\w+=\w+&\w+=\w+/
      actual = @web_module.fetch('test.php', :name => 'foo', :term => 'bar')
      assert_match(expected, actual)
    end
  end

  class WebInterfaceTest < WebTest

    def setup
      super
      @expected = OpenStruct.new
      @expected.base_uri = 'http://www.urbandictionary.com/define.php?term=impromptu'

      @web_module.stub(:open) do |arg|
        result = OpenStruct.new
        result.base_uri = 'http://www.urbandictionary.com/define.php?term=impromptu'
        result
      end
    end

    def test_returns_response_for_random_word
      actual = @web_module.random

      assert_equal(@expected.base_uri, actual.url)
      assert_equal(@expected, actual.stream)
    end

    def test_returns_response_for_define_with_phrase
      actual = @web_module.search('cookie monster')

      assert_equal(@expected.base_uri, actual.url)
      assert_equal(@expected, actual.stream)
    end
  end
end

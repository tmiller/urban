require "test_helper"
require "urban/web"

class WebTest < Urban::Test
  attr_accessor :web_client

  def setup
    self.web_client = Urban::Web.new
  end

  class WebFetchTest < WebTest

    def setup
      @reflect_args = lambda { |a| a }
      super
    end

    def test_fetch_with_no_params
      expected = "http://www.urbandictionary.com/test.php"
      web_client.stub :open, @reflect_args do
        actual = web_client.fetch("test.php")
        assert_equal(expected, actual)
      end
    end

    def test_fetch_with_params
      expected = "http://www.urbandictionary.com/test.php?term=bar&name=foo"
      web_client.stub :open, @reflect_args do
        actual = web_client.fetch("test.php", :term => "bar", :name => "foo")
        assert_match expected, actual
      end
    end
  end

  class WebInterfaceTest < WebTest

    def setup
      @expected = OpenStruct.new(
        :base_uri => "http://www.urbandictionary.com/define.php?term=impromptu"
      )
      super
    end

    def test_returns_response_for_random_word
      web_client.stub :open, @expected do
        actual = web_client.random
        assert_equal @expected.base_uri, actual.url
        assert_equal @expected, actual.stream
      end
    end

    def test_returns_response_for_define_with_phrase
      web_client.stub :open, @expected do
        actual = web_client.search("cookie monster")
        assert_equal @expected.base_uri, actual.url
        assert_equal @expected, actual.stream
      end
    end
  end
end

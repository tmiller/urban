require "test_helper"
require "urban/web"

class WebTest < Urban::Test

  class WebFetchTest < WebTest
    def setup
      @reflect_args = lambda { |a| a }
    end

    def test_fetch_with_no_params
      expected = "http://www.urbandictionary.com/test.php"
      Kernel.stub :open, @reflect_args do
        actual = Urban::Web.fetch("test.php")
        assert_equal(expected, actual)
      end
    end

    def test_fetch_with_params
      expected = /http:\/\/www\.urbandictionary\.com\/test\.php\?\w+=\w+&\w+=\w+/
      Kernel.stub :open, @reflect_args do
        actual = Urban::Web.fetch("test.php", :term => "bar", :name => "foo")
        assert_match expected, actual
      end
    end
  end

  class WebInterfaceTest < WebTest

    def setup
      @expected = OpenStruct.new(
        :base_uri => "http://www.urbandictionary.com/define.php?term=impromptu"
      )
    end

    def test_returns_response_for_random_word
      Kernel.stub :open, @expected do
        actual = Urban::Web.random
        assert_equal @expected.base_uri, actual.url
        assert_equal @expected, actual.stream
      end
    end

    def test_returns_response_for_define_with_phrase
      Kernel.stub :open, @expected do
        actual = Urban::Web.search("cookie monster")
        assert_equal @expected.base_uri, actual.url
        assert_equal @expected, actual.stream
      end
    end
  end
end

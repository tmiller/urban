require "test_helper"
require "urban/web"

class WebTest < Urban::Test

  attr_accessor :web_client

  def setup
    self.web_client = Urban::Web.new
  end

  def test_build_query_with_multiple_query_params
    expected = "?term=bar&name=foo"
    actual = web_client.send :build_query, { :term => :bar, :name => :foo }
    assert_equal expected, actual
  end

  def test_build_uri_with_no_query_params
    expected = "http://www.urbandictionary.com/test.php"
    actual = web_client.send :build_uri, :test
    assert_equal expected, actual
  end

  def test_build_uri_with_a_query_param
    expected = "http://www.urbandictionary.com/test.php?term=foo"
    actual = web_client.send :build_uri, :test, { :term => :foo }
    assert_equal expected, actual
  end

  def test_build_response
    response = OpenStruct.new :base_uri =>
      "http://www.urbandictionary.com/define.php?term=impromptu"
    expected = Urban::Web::Response.new response.base_uri, response
    actual = web_client.send :build_response, response
    assert_equal expected, actual
  end

end

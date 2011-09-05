require 'test_helper'

class WebTest < MiniTest::Unit::TestCase

  def setup
    @web_module = (Object.new).extend(Urban::Web).extend(Stub)
    @web_module.stub(:open) { |arg| return arg; }
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

  def test_returns_html_for_random_word
    expected = 'http://www.urbandictionary.com/random.php'
    actual = @web_module.random
    assert_equal(expected, actual)
  end

  def test_web_sends_request_to_define_with_phrase
    expected = 'http://www.urbandictionary.com/define.php?term=cookie%20monster'
    actual = @web_module.search('cookie monster')
    assert_equal(expected, actual)
  end
end

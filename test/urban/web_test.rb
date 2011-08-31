require 'test_helper'

class WebTest < MiniTest::Unit::TestCase

  def setup
    @web_service = (Urban::Web.new).extend Stub
    @web_service.stub(:open) { |arg| return arg; }
  end

  def test_web_sends_request_to_random
    expected = 'http://www.urbandictionary.com/random.php'
    actual = @web_service.query(:random)
    assert_equal(expected, actual)
  end

  def test_web_sends_request_to_define_with_phrase
    expected = 'http://www.urbandictionary.com/define.php?term=Cookie%20monster'
    actual = @web_service.query(:define, 'Cookie monster')
    assert_equal(expected, actual)
  end
end

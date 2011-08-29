require 'test_helper'
require 'ostruct'

class DictionaryTest < MiniTest::Unit::TestCase

  def setup
    @dictionary = Urban::Dictionary.new
    @options = OpenStruct.new
    @api = MiniTest::Mock.new
  end

  def test_dictionary_calls_random
    @options.random = true
    @api.expect(:query, nil, [:random])

    @dictionary.api = @api
    @dictionary.define(@options)
    @api.verify
  end

  def test_dictionary_calls_define
    @options.phrase = 'Cookie monster'
    @api.expect(:query, nil , [:define, 'Cookie monster'])

    @dictionary.api = @api
    @dictionary.define(@options)
    @api.verify
  end
end

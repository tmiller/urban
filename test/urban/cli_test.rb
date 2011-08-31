require 'test_helper'

class CLITest < MiniTest::Unit::TestCase

  def program
    @program ||= instance_eval do
      (Urban::CLI.new).extend Stub
    end
  end

  def assert_cli_prints(expected)
    out, err = capture_io { yield }

    if expected.respond_to?(:each)
      expected.each do |expect|
        assert_match(expect, out)
      end
    else
      assert_match(expected, out)
    end
  end

  def test_parse_prints_help
    expectations = [
      /Usage: urban \[OPTION\]\.\.\. \[PHRASE\]/,
      /Search http:\/\/urbandictionary\.com for definitions/,
      /-l, --list\s*List all definitions/,
      /-r, --random\s*Find random word on urban dictionary/,
      /-h, --help\s*Show this message/,
      /-version\s*Show version/
    ]
    assert_cli_prints expectations do
      program.run(["-h"])
    end
  end

  def test_parse_prints_version_info
    assert_cli_prints(/^Urban \d+\.\d+\.\d+ \(c\) Thomas Miller$/) do
      program.run(["-v"])
    end
  end

  def test_no_args_prints_help
      assert_cli_prints(/Usage: urban \[OPTION\]\.\.\. \[PHRASE\]/) do
        program.run([])
      end
  end

  def test_parse_returns_random
    capture_io do
      actual = program.send(:parse, '-r'.to_args)
      assert(actual.random, 'Args -r; Expected true, returned false')
      actual = program.send(:parse, '--random'.to_args)
      assert(actual.random, 'Args --random Expected true, returned false')
    end
  end

  def test_parse_returns_list
    capture_io do
      actual = program.send(:parse, '-l'.to_args)
      assert(actual.list, 'Args: -l; Expected true, returned false')
      actual = program.send(:parse, '--list'.to_args)
      assert(actual.list, 'Args: --list; Expected true, returned false')
    end
  end

  def test_parse_returns_phrase
    capture_io do
      actual = program.send(:parse, 'Cookie monster'.to_args)
      assert_equal('Cookie monster', actual.phrase)
      actual = program.send(:parse, ['Cookie monster'])
      assert_equal('Cookie monster', actual.phrase)
    end
  end

  def test_cli_prints_random_definition
    dictionary = MiniTest::Mock.new
    expected = [ TEST_PHRASE.word,
                 TEST_PHRASE.definitions.first ]
    capture_io do
      program.stub(:dictionary) do
        dictionary.expect(:random, TEST_PHRASE)
      end
    end
    assert_cli_prints(expected) { program.run(['-r']) }
    dictionary.verify
  end

  def test_cli_prints_random_definition_list
    dictionary = MiniTest::Mock.new
    expected = [ TEST_PHRASE.word,
                 *TEST_PHRASE.definitions ]
    capture_io do
      program.stub(:dictionary) do
        dictionary.expect(:random, TEST_PHRASE)
      end
    end
    assert_cli_prints(expected) { program.run(['-rl']) }
    dictionary.verify
  end

  def test_cli_prints_definition
    dictionary = MiniTest::Mock.new
    expected = [ TEST_PHRASE.word,
                 TEST_PHRASE.definitions.first ]
    capture_io do
      program.stub(:dictionary) do
        dictionary.expect(:define, TEST_PHRASE, 'impromptu')
      end
    end
    assert_cli_prints(expected) { program.run(['impromptu']) }
    dictionary.verify
  end

end

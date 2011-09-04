require 'test_helper'

class CLITest < MiniTest::Unit::TestCase

  def setup
    @program = Urban::CLI.new
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
    assert_cli_prints(expectations) { @program.run(["-h"]) }
  end

  def test_parse_prints_version_info
    args = ['-v']
    assert_cli_prints(/^Urban \d+\.\d+\.\d+ \(c\) Thomas Miller$/) { @program.run(args) }
  end

  def test_no_args_prints_help
    args = []
    assert_cli_prints(/Usage: urban \[OPTION\]\.\.\. \[PHRASE\]/) { @program.run(args) }
  end

  def test_no_args_with_list_option_prints_help
    args = ['-l']
    assert_cli_prints(/Usage: urban \[OPTION\]\.\.\. \[PHRASE\]/) { @program.run(args) }
  end

  def test_parse_returns_random
    capture_io do
      actual = @program.send(:parse, ['-r'])
      assert(actual.random, 'Args -r; Expected true, returned false')
      actual = @program.send(:parse, ['--random'])
      assert(actual.random, 'Args --random Expected true, returned false')
    end
  end

  def test_parse_returns_list
    capture_io do
      actual = @program.send(:parse, ['-l'])
      assert(actual.list, 'Args: -l; Expected true, returned false')
      actual = @program.send(:parse, ['--list'])
      assert(actual.list, 'Args: --list; Expected true, returned false')
    end
  end

  def test_parse_returns_phrase
    capture_io do
      actual = @program.send(:parse, ['Cookie', 'monster'])
      assert_equal('Cookie monster', actual.phrase)
      actual = @program.send(:parse, ['Cookie monster'])
      assert_equal('Cookie monster', actual.phrase)
    end
  end

  class CLIDefinintionOutputTest < CLITest
    def setup
      @dictionary = MiniTest::Mock.new
      super
    end

    def test_cli_prints_random_definition
      args = ['-r']
      expected = [ "#{TEST_PHRASE.word.upcase}", TEST_PHRASE.definitions.first ]
      @program.dictionary = @dictionary.expect(:random, TEST_PHRASE)
      assert_cli_prints(expected) { @program.run(args) }
      @dictionary.verify
    end

    def test_cli_prints_random_definition_list
      args = ['-rl']
      expected = [ "#{TEST_PHRASE.word.upcase}", *TEST_PHRASE.definitions ]
      @program.dictionary = @dictionary.expect(:random, TEST_PHRASE)
      assert_cli_prints(expected) { @program.run(args) }
      @dictionary.verify
    end

    def test_cli_prints_definition
      args = ['impromptu']
      expected = [ "#{TEST_PHRASE.word.upcase}", TEST_PHRASE.definitions.first ]
      @program.dictionary = @dictionary.expect(:search, TEST_PHRASE, ['impromptu'])
      assert_cli_prints(expected) { @program.run(['impromptu']) }
      @dictionary.verify
    end

    def test_cli_prints_definition_list
      args = ['-l', 'impromptu']
      expected = [ "#{TEST_PHRASE.word.upcase}", *TEST_PHRASE.definitions ]
      @program.dictionary = @dictionary.expect(:search, TEST_PHRASE, ['impromptu'])
      assert_cli_prints(expected) { @program.run(args) }
      @dictionary.verify
    end
  end
end

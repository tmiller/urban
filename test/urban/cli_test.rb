require 'test_helper'

class CLITest < MiniTest::Unit::TestCase

  let(:program) { |args| Urban::CLI.new(args.first.to_args) }

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

  def test_prints_help
    expectations = [
      /Usage: urban \[OPTION\]\.\.\. \[PHRASE\]/,
      /Search http:\/\/urbandictionary\.com for definitions/,
      /-l, --list\s*List all definitions/,
      /-r, --random\s*Find random word on urban dictionary/,
      /-h, --help\s*Show this message/,
      /-version\s*Show version/
    ]
    assert_cli_prints expectations do
     program("-h") 
    end
  end

  def test_prints_version_info
    assert_cli_prints /^Urban \d+\.\d+\.\d+ \(c\) Thomas Miller$/ do
      program("-v")
    end
  end
end

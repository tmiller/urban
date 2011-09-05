require 'test_helper'
require 'shellwords'

class CLITest < MiniTest::Unit::TestCase

  HELP_SCREEN = <<-EOS
Usage: urban [OPTION]... [PHRASE]
Search http://urbandictionary.com for definitions of phrases

Options:
    -a, --all                        List all definitions
    -r, --random                     Return a random phrase and definition
    -h, --help                       Show this message
    -v, --version                    Show version information

Examples:
    urban cookie monster        Search for "cookie monster" and print its
                                first definition
    urban -a cookie monster     Search for "cookie monster" and print all of
                                its available definitions
    urban -r                    Print a random phrase and its first definition
    urban -ra                   Print a random phrase and all of its available
                                definitions

EOS

  def setup
    @program = Urban::CLI.new
  end

  class CLIArgumentParsingTest < CLITest

    # Helpers
    def assert_flag_is_set(name)
      ["-#{name.chars.first}", "--#{name}"].each do |args|
        options = @program.send(:parse, [args])
        assert_equal(true, options.send(name))
      end
    end

    # Tests
    def test_defaults
      assert_silent do
        options = @program.send(:parse, [])
        assert_equal(false, options.help)
        assert_equal(false, options.version)
        assert_equal(false, options.random)
        assert_equal(false, options.all)
        assert_equal('', options.phrase)
      end
    end

    def test_phrase
      assert_silent do
        options = @program.send(:parse, ['foo bar'])
        assert_equal('foo bar', options.phrase)
      end
    end

    def test_help_flag
      assert_silent do
        assert_flag_is_set('help')
      end
    end

    def test_version_flag
      assert_silent do
        assert_flag_is_set('version')
      end
    end

    def test_random_flag
      assert_silent do
        assert_flag_is_set('random')
      end
    end

    def test_all_flag
      assert_silent do
        assert_flag_is_set('all')
      end
    end
  end

  class CLIRunnerStandardOutputTest < CLITest

    SINGLE_DEFINITION = "\n#{TEST_ENTRY.word.upcase}\n\n#{TEST_ENTRY.definitions.first}\n\n"
    MULTIPLE_DEFINITIONS = "\n#{TEST_ENTRY.word.upcase}\n\n#{TEST_ENTRY.definitions.join("\n\n")}\n\n"

    def setup
      super
      @dictionary = MiniTest::Mock.new
    end

    # Helpers
    def assert_program_output(argument_variations, stdout=nil, stderr=nil)
      argument_variations.each do |args|
        assert_output(stdout, stderr) { @program.run(Shellwords.shellwords(args)) }
      end
    end

    # Tests
    def test_help_flag_prints_help
      assert_output(HELP_SCREEN) { @program.run([]) }
    end

    def test_version_flag_prints_version
      ['-v', '--v'].each do |args|
        assert_output("Urban #{Urban::VERSION} (c) Thomas Miller\n") { @program.run([args]) }
      end
    end

    def test_random_flag_prints_single_definition
      @program.dictionary = @dictionary.expect(:random, TEST_ENTRY)
      argument_variations = ['-r', '--random']
      assert_program_output(argument_variations, SINGLE_DEFINITION)
      @dictionary.verify
    end

    def test_random_and_list_flag_prints_multiple_definitions
      @program.dictionary = @dictionary.expect(:random, TEST_ENTRY)
      argument_variations = ['-ra', '-r -a', '--random -a', '-r --all', '--all --random']
      assert_program_output(argument_variations, MULTIPLE_DEFINITIONS)
      @dictionary.verify
    end

    def test_phrase_prints_single_definition
      @program.dictionary = @dictionary.expect(:search, TEST_ENTRY, ['impromptu'])
      argument_variations = ['impromptu']
      assert_program_output(argument_variations, SINGLE_DEFINITION)
      @dictionary.verify
    end

    def test_phrase_and_list_flag_prints_multiple_definitions
      @program.dictionary = @dictionary.expect(:search, TEST_ENTRY, ['impromptu'])
      argument_variations = ['impromptu -a', '--all impromptu']
      assert_program_output(argument_variations, MULTIPLE_DEFINITIONS)
      @dictionary.verify
    end
  end
end

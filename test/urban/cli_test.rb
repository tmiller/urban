require 'test_helper'
require 'open-uri'
require 'socket'
require 'shellwords'

class CLITest < MiniTest::Unit::TestCase

  HELP_SCREEN = <<-EOS
Usage: urban [OPTION]... [PHRASE]
Search http://urbandictionary.com for definitions of phrases

Options:
    -a, --all                        List all definitions
    -r, --random                     Return a random phrase and definition
    -u, --url                        Print the definition's url after the definition
    -h, --help                       Show this message
    -v, --version                    Show version information
    -l, --list                       DEPRECATED please use --all or -a instead

Examples:
    urban cookie monster        Search for "cookie monster" and print its
                                first definition
    urban -a cookie monster     Search for "cookie monster" and print all of
                                its available definitions
    urban -r                    Print a random phrase and its first definition
    urban -ra                   Print a random phrase and all of its available
                                definitions

EOS

  # Helpers
  def run_program(args)
    @program.run(Shellwords.shellwords(args))
  end

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

    def test_all_flag
      assert_silent do
        assert_flag_is_set('url')
      end
    end
  end

  class CLIRunnerStandardOutputTest < CLITest

    SINGLE_DEFINITION = "\n#{TEST_ENTRY.phrase.upcase}\n\n#{TEST_ENTRY.definitions.first}\n\n"
    MULTIPLE_DEFINITIONS = "\n#{TEST_ENTRY.phrase.upcase}\n\n#{TEST_ENTRY.definitions.join("\n\n")}\n\n"
    DEFINITION_WITH_URL = "\n#{TEST_ENTRY.phrase.upcase}\n\n#{TEST_ENTRY.definitions.first}\n\nURL: #{TEST_ENTRY.url}\n\n"

    def setup
      super
      @dictionary = MiniTest::Mock.new
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
      assert_output(SINGLE_DEFINITION) { run_program "-r" }
      assert_output(SINGLE_DEFINITION) { run_program "--random" }
      @dictionary.verify
    end

    def test_phrase_prints_single_definition
      @program.dictionary = @dictionary.expect(:search, TEST_ENTRY, ['impromptu'])
      assert_output(SINGLE_DEFINITION) { run_program "impromptu" }
      @dictionary.verify
    end

    def test_random_and_all_flag_prints_multiple_definitions
      @program.dictionary = @dictionary.expect(:random, TEST_ENTRY)
      assert_output(MULTIPLE_DEFINITIONS) { run_program "-ra" }
      assert_output(MULTIPLE_DEFINITIONS) { run_program "-r -a" }
      assert_output(MULTIPLE_DEFINITIONS) { run_program "--random -a" }
      assert_output(MULTIPLE_DEFINITIONS) { run_program "-r --all" }
      assert_output(MULTIPLE_DEFINITIONS) { run_program "--all --random" }
      @dictionary.verify
    end

    def test_phrase_and_all_flag_prints_multiple_definitions
      @program.dictionary = @dictionary.expect(:search, TEST_ENTRY, ['impromptu'])
      assert_output(MULTIPLE_DEFINITIONS) { run_program "impromptu -a" }
      assert_output(MULTIPLE_DEFINITIONS) { run_program "--all impromptu" }
      @dictionary.verify
    end

    def test_random_and_url_flag_prints_definition_with_url
      @program.dictionary = @dictionary.expect(:random, TEST_ENTRY)
      assert_output(DEFINITION_WITH_URL) { run_program "-ru" }
      assert_output(DEFINITION_WITH_URL) { run_program "-r -u" }
      assert_output(DEFINITION_WITH_URL) { run_program "--random -u" }
      assert_output(DEFINITION_WITH_URL) { run_program "-r --url" }
      assert_output(DEFINITION_WITH_URL) { run_program "--url --random" }
      @dictionary.verify
    end

    def test_phrase_and_url_flag_prints_definition_with_url
      @program.dictionary = @dictionary.expect(:search, TEST_ENTRY, ['impromptu'])
      assert_output(DEFINITION_WITH_URL) { run_program "impromptu -u" }
      assert_output(DEFINITION_WITH_URL) { run_program "--url impromptu" }
      @dictionary.verify
    end

    def test_list_flag_prints_deprecation_warning
      expected = /WARNING: --list and -l are deprecated please use --all or -a instead/
      @program.dictionary = @dictionary.expect(:search, TEST_ENTRY, ['impromptu'])
      @program.dictionary = @dictionary.expect(:random, TEST_ENTRY)
      stdout, stederr = capture_io { run_program '--list impromptu' }
      assert_match expected, stdout
      stdout, stederr  = capture_io { @program.run(Shellwords.shellwords('-rl')) }
      assert_match expected, stdout
    end
  end

  class CLIRunnerErrorOutputTest < CLITest

    ERROR_MISSING_PHRASE = "urban: no definitions found for #{EMPTY_ENTRY.phrase.upcase}.\n"
    ERROR_NO_INTERNET = "urban: no internet connection available.\n"
    ERROR_INVALID_OPTION = <<-EOE
urban: invalid option: -b
Try `urban --help' for more information.
    EOE

    def setup
      super
    end

    # Tests
    def test_search_missing_phrase_prints_error
      dictionary = MiniTest::Mock.new
      @program.dictionary = dictionary.expect(:search, EMPTY_ENTRY, ['gubble'])
      assert_output(nil, ERROR_MISSING_PHRASE) { run_program("gubble") }
      dictionary.verify
    end

    def test_search_missing_phrase_prints_error
      dictionary = (Object.new).extend Stub
      dictionary.stub(:search) { |phrase| raise SocketError }
      @program.dictionary = dictionary
      assert_output(nil, ERROR_NO_INTERNET) { run_program("gubble") }
    end

    def test_invalid_option_prints_help
      assert_output(nil, ERROR_INVALID_OPTION) { run_program("-b") }
    end
  end
end

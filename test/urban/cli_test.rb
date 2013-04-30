require "test_helper"
require "shellwords"
require "urban/cli"

class CLITest < Urban::Test

  attr_accessor :program

  def run_program(args)
    program.run(Shellwords.shellwords(args))
  end

  def setup
    self.program = Urban::CLI.new
  end

  class CLIArgumentParsingTest < CLITest

    def assert_flag_is_set(name)
      ["-#{name.chars.first}", "--#{name}"].each do |args|
        options = program.send(:parse, [args])
        assert options.send(name)
      end
    end

    def test_defaults
      options = program.send(:parse, [])
      refute options.help
      refute options.version
      refute options.random
      refute options.all
      assert_empty options.phrase
    end

    def test_phrase
      options = program.send :parse, ["foo bar"]
      assert_equal "foo bar", options.phrase
    end

    def test_version_flag
      assert_flag_is_set "version"
    end

    def test_random_flag
      assert_flag_is_set "random"
    end

    def test_all_flag
      assert_flag_is_set "all"
    end

    def test_url_flag
      assert_flag_is_set "url"
    end
  end

  class CLIRunnerStandardOutputTest < CLITest

    attr_accessor :dictionary

    def setup
      super
      self.dictionary = Urban::Dictionary.new
      program.dictionary = dictionary
    end

    def test_help_flag_prints_help
      help_screen = load_fixture "screens/help.txt"
      assert_output(help_screen, "") { program.run([]) }
    end

    def test_version_flag_prints_version
      version_screen = "Urban #{Urban::VERSION} (c) Thomas Miller\n"
      assert_output(version_screen, "") { run_program "--version" }
    end

    def test_random_flag_prints_single_definition
      single_definition = load_fixture "screens/definition.txt"

      dictionary.stub(:random, test_entry) do
        assert_output(single_definition, "") { run_program "--random" }
      end
    end

    def test_phrase_prints_single_definition
      single_definition = load_fixture "screens/definition.txt"
      dictionary.stub(:search, test_entry) do
        assert_output(single_definition, "") { run_program "impromptu" }
      end
    end

    def test_random_and_all_flag_prints_multiple_definitions
      multiple_definitions = load_fixture "screens/definitions.txt"
      dictionary.stub(:random, test_entry) do
        assert_output(multiple_definitions, "") { run_program "--all --random" }
      end
    end

    def test_phrase_and_all_flag_prints_multiple_definitions
      multiple_definitions = load_fixture "screens/definitions.txt"
      dictionary.stub(:search, test_entry) do
        assert_output(multiple_definitions, "") { run_program "--all impromptu" }
      end
    end

    def test_random_and_url_flag_prints_definition_with_url
      definition_with_url = load_fixture "screens/definition_with_url.txt"
      dictionary.stub(:random, test_entry) do
        assert_output(definition_with_url, "") { run_program "--url --random" }
      end
    end

    def test_phrase_and_url_flag_prints_definition_with_url
      definition_with_url = load_fixture "screens/definition_with_url.txt"
      dictionary.stub(:search, test_entry) do
        assert_output(definition_with_url, "") { run_program "--url impromptu" }
      end
    end

  end

  class CLIRunnerErrorOutputTest < CLITest

    attr_accessor :dictionary

    def setup
      super
      self.dictionary = Urban::Dictionary.new
      program.dictionary = dictionary
    end

    def test_search_missing_phrase_prints_error
      missing_phrase_error = load_fixture "screens/missing_phrase_error.txt"

      dictionary.stub :search, empty_entry do
        assert_output("", missing_phrase_error) { run_program("gubble") }
      end
    end


    def test_search_with_no_internet_prints_error
      no_internet_error = load_fixture "screens/no_internet_error.txt"
      raise_socket_error = Proc.new { raise SocketError }

      dictionary.stub :search, raise_socket_error do
        assert_output("", no_internet_error) { run_program("gubble") } 
      end
    end

    def test_invalid_option_prints_help
      invalid_option_error = load_fixture "screens/invalid_option_error.txt"
      assert_output("", invalid_option_error) { run_program("-b") }
    end
  end
end

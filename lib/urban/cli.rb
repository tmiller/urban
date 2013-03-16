require 'optparse'
require 'ostruct'
require 'socket'
require 'urban/dictionary'

module Urban
  class CLI

    attr_accessor :dictionary

    def initialize
      @dictionary = Urban::Dictionary
    end

    def run(args = ARGV)
      options = parse(args)

      results = case
        when options.random         ; dictionary.random
        when !options.phrase.empty? ; dictionary.search(options.phrase)
        when options.version        ; version
        else                        ; usage
      end

      if results.respond_to?(:phrase)
        if results.definitions
          generate_output(results, options)
        else
          error "no definitions found for #{results.phrase.upcase}."
        end
      else
        puts results
      end

    rescue SocketError
      error 'no internet connection available.'
    rescue OptionParser::InvalidOption => e
      error "#{e.message}\nTry `urban --help' for more information."
    rescue StandardError => e
      error e.message
    end

    private

    def error(message)
      $stderr.puts "urban: #{message}"
    end

    def generate_output(entry, options)
      output = "\n#{entry.phrase.upcase}\n\n"
      if options.all
        output << "#{entry.definitions.join("\n\n")}\n\n"
      else
        output << "#{entry.definitions.first}\n\n"
      end
      output << "URL: #{entry.url}\n\n" if options.url

      puts output
    end

    def parse(args)
      options = OpenStruct.new
      options.random, options.all, options.version, options.help = false

      options_parser = OptionParser.new do |o|
        o.on('-a', '--all') { options.all = true }
        o.on('-r', '--random') { options.random = true }
        o.on('-u', '--url') { options.url = true }
        o.on('-h', '--help')
        o.on('-v', '--version') { options.version = true }
      end

      options_parser.parse!(args)
      options.phrase = args.join(' ')
      options
    end

    def version
      "Urban #{Urban::VERSION} (c) Thomas Miller"
    end

    def usage
      <<-EOS
Usage: urban [OPTION]... [PHRASE]
Search http://urbandictionary.com for definitions of phrases

Options:
    -a, --all                        List all definitions
    -r, --random                     Return a random phrase and definition
    -u, --url                        Print the definition's url after the definition
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
    end
  end
end

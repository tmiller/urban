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
      begin
        options = parse(args)
        output = case
          when options.help           ; usage
          when options.version        ; version
          when options.random         ; dictionary.random
          when !options.phrase.empty? ; dictionary.search(options.phrase)
          else                        ; usage
        end

        if output.respond_to?(:phrase)
          if output.definitions
            print_entry(output, options)
          else
            error "no definitions found for #{output.phrase.upcase}."
          end
        else
          puts output
        end

      rescue SocketError
        error 'no internet connection available.'
      rescue OptionParser::InvalidOption => e
        error "#{e.message}\nTry `urban --help' for more information."
      rescue Exception => e
        error e.message
      end
    end

    private

    def error(message)
      $stderr.puts "urban: #{message}"
    end

    def print_entry(entry, options)
      puts "\n#{entry.phrase.upcase}\n\n"
      if options.all
        entry.definitions.each { |definition| puts "#{definition}\n\n" }
      else
        puts "#{entry.definitions.first}\n\n"
      end
      puts "URL: #{entry.url}\n\n" if options.url
    end

    def parse(args)
      options = OpenStruct.new
      options.random, options.all, options.version, options.help = false

      options_parser = OptionParser.new do |o|
        o.on('-a', '--all') { options.all = true }
        o.on('-r', '--random') { options.random = true }
        o.on('-u', '--url') { options.url = true }
        o.on('-h', '--help') { options.help = true }
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

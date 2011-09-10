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
          when options.help           ; options.help_screen
          when options.version        ; "Urban #{Urban::VERSION} (c) Thomas Miller"
          when options.random         ; dictionary.random
          when !options.phrase.empty? ; dictionary.search(options.phrase)
          else                        ; options.help_screen
        end

        if output.respond_to?(:phrase)
          if output.definitions
            print_entry(output, options)
          else
            $stderr.puts "urban: no definitions found for #{entry.phrase.upcase}."
          end
        else
          puts output
        end

      rescue SocketError
        $stderr.puts 'urban: no internet connection available.'
      rescue OptionParser::InvalidOption => e
        $stderr.puts "urban: #{e.message}\nTry `urban --help' for more information."
      rescue Exception => e
        $stderr.puts e.message
      end
    end

    private

    def print_error(entry)
    end

    def print_entry(entry, options)
      puts "WARNING: --list and -l are deprecated please use --all or -a instead" if options.list
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
      options.random = options.all = options.version = options.help = false

      opts = OptionParser.new do |o|
        o.banner = <<-EOB
Usage: urban [OPTION]... [PHRASE]
Search http://urbandictionary.com for definitions of phrases

        EOB

        o.separator "Options:"
        o.on('-a', '--all', 'List all definitions') do
          options.all = true
        end

        o.on('-r', '--random', 'Return a random phrase and definition') do
          options.random = true
        end

        o.on('-u', '--url', "Print the definition's url after the definition") do
          options.url = true
        end

        o.on('-h', '--help', 'Show this message') do
          options.help = true
        end

        o.on('-v', '--version', 'Show version information') do
          options.version = true
        end

        o.on('-l', '--list', 'DEPRECATED please use --all or -a instead') do
          options.list = true
          options.all = true
        end
      end

      examples = <<-EOE

Examples:
    urban cookie monster        Search for "cookie monster" and print its
                                first definition
    urban -a cookie monster     Search for "cookie monster" and print all of
                                its available definitions
    urban -r                    Print a random phrase and its first definition
    urban -ra                   Print a random phrase and all of its available
                                definitions

      EOE
      opts.parse!(args)
      options.phrase = args.join(' ')
      options.help_screen = opts.help + examples
      options
    end
  end
end

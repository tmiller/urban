require 'optparse'
require 'ostruct'
require 'urban/dictionary'

module Urban
  class CLI

    attr_accessor :dictionary

    def initialize
      @dictionary = Urban::Dictionary.new
    end

    def run(args = ARGV)
      options = parse(args)
      output = case
        when options.help           ; options.help_screen
        when options.version        ; "Urban #{Urban::VERSION} (c) Thomas Miller"
        when options.random         ; dictionary.random
        when !options.phrase.empty? ; dictionary.search(options.phrase)
        else                        ; options.help_screen
      end
      if output.respond_to?(:word)
        print_entry(output, options.all)
      else
        puts output
      end
    end

    private

    def print_entry(entry, display_all)
      puts "\n#{entry.word.upcase}\n\n"
      if display_all
        entry.definitions.each { |definition| puts "#{definition}\n\n" }
      else
        puts "#{entry.definitions.first}\n\n"
      end
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

        o.on('-h', '--help', 'Show this message') do
          options.help = true
        end

        o.on('-v', '--version', 'Show version information') do
          options.version = true
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

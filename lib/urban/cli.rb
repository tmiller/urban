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
        print_entry(output, options.list)
      else
        puts output
      end
    end

    private

    def print_entry(entry, list)
      puts "\n#{entry.word.upcase}\n\n"
      if list
        entry.definitions.each { |definition| puts "#{definition}\n\n" }
      else
        puts "#{entry.definitions.first}\n\n"
      end
    end

    def parse(args)
      options = OpenStruct.new
      options.random = options.list = options.version = options.help = false

      opts = OptionParser.new do |o|
        o.banner = %Q{Usage: urban [OPTION]... [PHRASE]
                      Search http://urbandictionary.com for definitions}.gsub(/\n\s*/, "\n")

        o.separator "\nOptions"
        o.on('-l', '--list', 'List all definitions') do
          options.list = true
        end

        o.on('-r', '--random', 'Find random word on urban dictionary') do
          options.random = true
        end

        o.on('-h', '--help', 'Show this message') do
          options.help = true
        end

        o.on('-v', '--version', 'Show version') do
          options.version = true
        end
      end
      opts.parse!(args)
      options.phrase = args.join(' ')
      options.help_screen = opts
      options
    end
  end
end

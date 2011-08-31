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
      results = case
        when options.exit then return
        when options.random then dictionary.random
        when exists?(options.phrase) then dictionary.search(options.phrase)
        else return
      end
      print(results, options.list)
    end

    private

    def print(results, list)
      puts "#{results.word}:\n"
      if list
        results.definitions.each { |definition| puts "#{definition}\n" }
      else
        puts results.definitions.first
      end
    end

    def exists?(string)
      !(string.nil? || string.empty?)
    end

    def parse(args)
      options = OpenStruct.new
      options.random = false
      options.list = false
      options.phrase = ''
      opts = OptionParser.new do |o|
        o.banner = "Usage: urban [OPTION]... [PHRASE]"
        o.separator "Search http://urbandictionary.com for definitions"

        o.separator ''
        o.on('-l', '--list', 'List all definitions') do
          options.list = true
        end

        o.on('-r', '--random', 'Find random word on urban dictionary') do
          options.random = true
        end

        o.on('-h', '--help', 'Show this message') do
          puts o
          options.exit = true
        end

        o.on('--version', 'Show version') do
          puts "Urban #{Urban::VERSION} (c) Thomas Miller"
          options.exit = true
        end
      end
      if args.empty?
        puts opts
        options.exit = true
      end
      opts.parse!(args)
      options.phrase = args.join(' ')
      options
    end
  end
end

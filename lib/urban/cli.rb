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
        when !options.phrase.empty? then dictionary.search(options.phrase)
      end
      output_results(results, options.list)
    end

    private

    def output_results(results, list)
      puts "\n#{results.word.upcase}\n\n"
      if list
        results.definitions.each { |definition| puts "#{definition}\n\n" }
      else
        puts "#{results.definitions.first}\n\n"
      end
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
          options.exit = true
        end

        o.on('--version', 'Show version') do
          puts "Urban #{Urban::VERSION} (c) Thomas Miller"
          options.exit = true
        end
      end
      opts.parse!(args)
      options.phrase = args.join(' ')

      if (options.exit || !options.random && options.phrase.empty?)
        puts opts
        options.exit = true
      end

      options
    end
  end
end

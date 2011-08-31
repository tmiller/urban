require 'optparse'
require 'ostruct'
require 'urban/dictionary'

module Urban
  class CLI

    def run(args = ARGV)
      options = parse(args)
      case
      when options.exit
        return
      when options.random
        results = dictionary.random
        puts results.word
        if options.list then
          results.definitions.each { |definition| puts definition }
        else
          puts results.definitions.first
        end
      when !(options.phrase.nil? || options.phrase.empty?)
        results = dictionary.define(options.phrase)
        puts results.word
        puts results.definitions.first
      end
      puts ''
    end

    private

    def dictionary
      @dictionary ||= Urban::Dictionary.new
    end

    def parse(args)
      options = OpenStruct.new
      options.random = false
      options.list = false
      options.exit = false
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

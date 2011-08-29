require 'optparse'
require 'ostruct'
require 'urban/dictionary'

module Urban
  class CLI

    def initialize(args = ARGS)
      @options = parse(args)
    end

    def run
      dictionary.define(@options)
    end

    def dictionary
      @dictionary ||= Urban::Dictionary.new
    end

    private
    def parse(args)
      options = OpenStruct.new
      opts = OptionParser.new do |o|
        o.banner = "Usage: urban [OPTION]... [PHRASE]"
        o.separator "Search http://urbandictionary.com for definitions"

        o.separator ''
        o.on('-l', '--list', 'List all definitions') do
          puts opts
          options.list = true
        end

        o.on('-r', '--random', 'Find random word on urban dictionary') do
          puts o
          options.random = true
        end

        o.on('-h', '--help', 'Show this message') do
          puts o
          return nil
        end

        o.on('--version', 'Show version') do
          puts "Urban #{Urban::VERSION} (c) Thomas Miller"
          return nil
        end
      end

      if args.empty?
        puts opts
        return nil
      end
      opts.parse!(args)
      options.phrase = args.join(' ')
      options
    end

  end
end

require 'open-uri'
require 'urban/version'

module Urban
  class Web
    URL = 'http://www.urbandictionary.com'

    def query(type, word = nil)
      query = "#{type.to_s}.php" << (word ? "?term=#{word}" : '')
      open(escape_uri("#{URL}/#{query}"))
    end

  private
    def escape_uri(uri)
      if RUBY_VERSION > '1.9'
        URI::Parser.new.escape(uri)
      else
        URI.escape(uri)
      end
    end
  end
end

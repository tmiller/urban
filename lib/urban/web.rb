require 'urban/version'
require 'open-uri'

module Urban
  class Web
    URL = 'http://www.urbandictionary.com'

    def query(type, word = nil)
      query = "#{type.to_s}.php" << (word ? "?term=#{word}" : '')
      open(URI::Parser.new.escape("#{URL}/#{query}"))
    end
  end
end

require 'open-uri'
require 'urban/version'

module Urban
  module Web

    URL = 'http://www.urbandictionary.com'

    def search(phrase)
      fetch "define.php", :term => phrase
    end

    def random
      fetch "random.php"
    end

    def fetch(page, parameters = {})
      params = '?' +  parameters.map { |k,v| "#{k}=#{v}" }.join('&') unless parameters.empty?
      open(escape_uri("#{URL}/#{page}#{params}"))
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

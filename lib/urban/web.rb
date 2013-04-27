require 'open-uri'

module Urban
  module Web
    extend self

    Response = Struct.new(:url, :stream)

    attr_writer :url

    def search(phrase)
      result = fetch "define.php", :term => phrase
      Response.new(result.base_uri.to_s, result)
    end

    def random
      result = fetch "random.php"
      Response.new(result.base_uri.to_s, result)
    end

    def fetch(page, parameters = {})
      params = '?' +  parameters.map { |k,v| "#{k}=#{v}" }.join('&') unless parameters.empty?
      Kernel.open(escape_uri("#{url}/#{page}#{params}"))
    end

    def url
      @url ||= 'http://www.urbandictionary.com'
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

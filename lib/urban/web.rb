require 'open-uri'

module Urban
  class Web

    Response = Struct.new(:url, :stream)

    def search(phrase)
      build_response fetch :define, :term => phrase
    end

    def random
      build_response fetch :random
    end

    private

    def fetch(*args)
      open build_uri(*args)
    end

    def build_response(response)
      Response.new response.base_uri.to_s, response
    end

    def build_uri(page, params = nil)
      query = build_query(params) unless params.nil?
      escape_uri "#{url}/#{page}.php#{query}"
    end

    def build_query(parameters)
      "?" + parameters.map { |k,v| "#{k}=#{v}" }.join("&")
    end

    def escape_uri(uri)
      if RUBY_VERSION > '1.9'
        URI::Parser.new.escape uri
      else
        URI.escape uri
      end
    end

    def url
      "http://www.urbandictionary.com"
    end

  end
end

require 'nokogiri'
require 'urban/version'
require 'urban/web'

module Urban
  module Dictionary
    extend self

    Entry = Struct.new(:status, :word, :definitions, :source)
    attr_writer :web_service

    def random
      process(web_service.random)
    end

    def search(phrase)
      process(web_service.search(phrase))
    end

    def web_service
      @web_service ||= Urban::Web
    end

  private

    def process(response)
      document = Nokogiri::HTML(response.stream)
      Entry.new(:success,
                document.at_xpath('//td[@class="word"][1]').content.strip,
                parse_definitions(document),
                response.url)
    end

    def parse_definitions(document)
      definitions = document.xpath('//td/div[@class="definition"]').map do |node|
        node.xpath('//br').each { |br| br.replace(Nokogiri::XML::Text.new("\n", node.document)) };
        node.content.strip
      end
    end
  end
end

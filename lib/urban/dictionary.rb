require "nokogiri"

module Urban
  class Dictionary

    Entry = Struct.new(:phrase, :definitions, :url)

    attr_writer :web_service

    def random
      process(web_service.random)
    end

    def search(phrase)
      process(web_service.search(phrase))
    end

    def web_service
      @web_service ||= Urban::Web.new
    end

  private

    def process(response)
      document = Nokogiri::HTML(response.stream)
      if not_defined = document.at_xpath('//div[@id="not_defined_yet"]/i')
        Entry.new(not_defined.content.strip, nil, nil)
      else
        Entry.new(
          document.at_xpath('//a[@class="word"][1]').content.strip,
          parse_definitions(document),
          response.url
        )
      end
    end

    def parse_definitions(document)
      document.xpath('//div[@class="def-panel"]/div[@class="meaning"]').map do |node|
        node.xpath("//br").each { |br| br.replace(Nokogiri::XML::Text.new("\n", node.document)) };
        node.content.strip
      end
    end
  end
end

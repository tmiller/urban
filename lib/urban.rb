require "urban/version"

require 'open-uri'
require 'nokogiri'
require 'active_support/core_ext/string/inflections'

module Urban
  def self.random
    url = URI.encode('http://www.urbandictionary.com/random.php')
    doc = Nokogiri.HTML(open(url))
    word = clean_text(doc.at_css('.word')).humanize
    definition = clean_text(doc.at_css('.definition')).humanize.gsub(/\. \w/) { |char| char.upcase }
    puts "#{word}: #{definition}"
  end

  private
  def self.clean_text(node_set)
    node_set.children.each do |node|
      if node.name == 'br'
        node.remove
      else
        node.content = node.content.strip << ' '
      end
    end
    return node_set.content.strip.gsub(/ \./, '.')
  end

end

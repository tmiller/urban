require 'urban/dictionary'

module Urban

  def process
    begin
      result = ARGV.first ? define(ARGV.first) : random
      puts "#{result[:word]}: #{result[:definition]}"
    rescue
      puts "ERROR: #{ARGV.first.capitalize} not found!"
    end
  end

end

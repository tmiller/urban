require 'urban/dictionary'

module Urban

  def process
    begin
      result = ARGV.first ? define(ARGV.join(' ')) : random
      puts "#{result[:word]}: #{result[:definition]}"
    rescue
      puts "ERROR: #{ARGV.join(' ')} not found!"
    end
  end

end

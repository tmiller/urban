require 'urban/dictionary'

module Urban

  def self.process
    result = random
    puts "#{result[:word]}: #{result[:definition]}"
  end

end

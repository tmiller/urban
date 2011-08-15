require 'urban/dictionary'

module Urban

  def process
    result = random
    puts "#{result[:word]}: #{result[:definition]}"
  end

end

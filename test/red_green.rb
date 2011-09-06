require 'minitest/unit'

class RedGreen
  ESC = "\e["
  NND = "#{ESC}0m"

  attr_reader :io

  def initialize io
    @io = io
  end

  def red str
    colorize(31, str)
  end

  def green str
    colorize(32, str)
  end

  def colorize(color_code, str)
   "#{ESC}#{color_code}m#{str}#{NND}"
  end

  def print o
    case o
    when '.'
      io.print green(o)
    when 'E', 'F'
      io.print red(o)
    else
      io.print o
    end
  end

  def puts *o
    o.map! do |str|
     case str
       when /Failure:/, /Error:/, /[1-9]+ failures/, /[1-9]+ errors/; red(str)
       when /0 failures, 0 errors/; green(str)
       else; str
     end
    end
    super
  end

  def method_missing msg, *args
    io.send(msg, *args)
  end

end

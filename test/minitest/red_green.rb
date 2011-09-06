require 'minitest/unit'

class MiniTest::RedGreen
  ESC = "\e["
  NND = "#{ESC}0m"

  attr_reader :io

  def initialize io
    @io = io
  end

  def red str
    normal_color(31, str)
  end

  def yellow str
    bright_color(33, str)
  end

  def green str
    normal_color(32, str)
  end

  def normal_color(color_code, str)
   "#{ESC}#{color_code}m#{str}#{NND}"
  end

  def bright_color(color_code, str)
   "#{ESC}01;#{color_code}m#{str}#{NND}"
  end

  def print(o)
    case o
      when '.'; io.print green(o)
      when 'E', 'F'; io.print red(o)
      when 'S'; io.print yellow(o)
      else; io.print o
    end
  end

  def puts(*o)
    o.map! do |str|
      case str
        when /Failure:/, /Error:/, /[1-9]+ failures/, /[1-9]+ errors/;
          red(str)
        when /0 failures, 0 errors/;
          green(str).gsub(/([1-9]+ skips)/, yellow('\1'))
        else;
          str.gsub(/([1-9]+ skips)/, yellow('\1'))
      end
    end
    super
  end

  def method_missing(msg, *args)
    io.send(msg, *args)
  end
end

MiniTest::Unit.output = MiniTest::RedGreen.new(MiniTest::Unit.output)

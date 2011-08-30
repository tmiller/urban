require 'urban'
require 'urban/cli'
require 'minitest/autorun'
require 'redgreen'
require 'pry'

$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))

def load_file(filename)
  contents = ''
  File.open(File.expand_path("../data/#{filename}", __FILE__)) do |file|
    contents = file.read
  end
  contents
end

class String
  def to_args
    self.split(' ')
  end
end


require 'urban'
require 'urban/cli'
require 'minitest/autorun'
require 'redgreen'

$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))

class String
  def to_args
    self.split(' ')
  end
end



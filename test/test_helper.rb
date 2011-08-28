require 'urban'
require 'urban/cli'
require 'minitest/autorun'
require 'redgreen'

$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))

def let(name, &block)
  define_method name do |*args|
    @_memoized ||= {}
    @_memoized.fetch(name) { |k| @_memoized[k] = instance_exec(args, &block) }
  end
end

class String
  def to_args
    self.split(' ')
  end
end

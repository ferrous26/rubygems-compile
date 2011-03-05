$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'rubygems/command_manager'
require 'rubygems_plugin'

gem     'minitest', '>= 2.0.2'
require 'minitest/pride'
require 'minitest/autorun'

class MiniTest::Unit::TestCase
  def setup
    @command = Gem::Commands::CompileCommand.new
  end
end

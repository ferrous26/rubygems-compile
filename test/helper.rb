$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'rubygems/command_manager'
require 'rubygems_plugin'

gem     'minitest-macruby-pride', '>= 2.1.2'
require 'minitest/autorun'
require 'minitest/pride'

class MiniTest::Unit::TestCase
  def setup
    @command = Gem::Commands::CompileCommand.new
  end
end

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'rubygems/command_manager'
require 'rubygems_plugin'

gem     'minitest'
require 'minitest/pride'
require 'minitest/autorun'

class MiniTest::Unit::TestCase
  def setup
    @command = Gem::Commands::CompileCommand.new
  end
end

puts 'this suite only works if you have the rake gem installed'

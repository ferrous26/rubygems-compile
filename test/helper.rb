require 'rubygems'
require 'rubygems/command_manager'
require 'rubygems_plugin'

gem     'minitest', '>= 2.6.1'
require 'minitest/autorun'
require 'minitest/pride'

class MiniTest::Unit::TestCase
  def setup
    @command = Gem::Commands::CompileCommand.new
  end
end

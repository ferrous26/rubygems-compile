require 'rubygems'
require 'rubygems/command_manager'
require 'rubygems_plugin'

gem     'minitest-macruby-pride', '>= 2.2.0'
require 'minitest/autorun'
require 'minitest/pride'

class MiniTest::Unit::TestCase
  def setup
    @command = Gem::Commands::CompileCommand.new
  end
end

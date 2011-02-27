$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'rubygems/command_manager'
require 'rubygems_plugin'

require 'minitest/pride'
require 'minitest/autorun'

class MiniTest::Unit::TestCase
end

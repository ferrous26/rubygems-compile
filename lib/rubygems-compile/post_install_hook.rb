##
# The setting that we look for here is toggled using the +autocompile+
# command.

if Gem.configuration[:compile]
  require 'rubygems-compile/compiler'
  module Gem
    @post_install_hooks << ::Gem::Compiler.new
  end
end

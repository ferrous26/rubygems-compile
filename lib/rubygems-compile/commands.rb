require 'rubygems-compile/commands/compile_command'
Gem::CommandManager.instance.register_command :compile

require 'rubygems-compile/commands/uncompile_command'
Gem::CommandManager.instance.register_command :uncompile

require 'rubygems-compile/commands/autocompile_command'
Gem::CommandManager.instance.register_command :auto_compile

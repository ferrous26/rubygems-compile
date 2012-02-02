unless MACRUBY_REVISION.match /^git commit/

  ui = Gem::UserInteraction.new
  ui.alert_warning 'rubygems-compile requires MacRuby 0.11 or newer'
  ui.alert_warning 'rubygems-compile will not be loaded'

else

  require 'rubygems-compile/post_install_hook'
  require 'rubygems-compile/commands/compile_command'
  require 'rubygems-compile/commands/uncompile_command'
  require 'rubygems-compile/commands/autocompile_command'

  Gem::CommandManager.instance.register_command :compile
  Gem::CommandManager.instance.register_command :uncompile
  Gem::CommandManager.instance.register_command :auto_compile

end

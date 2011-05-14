if RUBY_VERSION.to_f < 0.11

  ui = Gem::UserInteraction.new
  ui.alert_warning 'rubygems-compile requires MacRuby 0.11 or newer'
  ui.alert_warning 'rubygems-compile will not be loaded'

else

  require 'rbconfig'
  require 'fileutils'

  unless Kernel.const_defined?(:Compiler)
    load File.join(RbConfig::CONFIG['bindir'], 'macrubyc')
  end

  require 'rubygems-compile/compiler'
  require 'rubygems-compile/commands'
  require 'rubygems-compile/post_install_hook'

end

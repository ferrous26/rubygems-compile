class Gem::Commands::AutoCompileCommand < Gem::Command
  include Gem::UserInteraction

  def initialize
    super 'auto_compile', 'Enable gem compilation at install time'
  end

  def description # :nodoc:
    'Toggle a setting that enables compiling gems at install time.'
  end

  def usage
    "#{progname}"
  end

  def execute
    Gem.configuration[:compile] = if Gem.configuration[:compile]
                                    say 'Disabling automatic compilation'
                                    false
                                  else
                                    say 'Enabling automatic compilation'
                                    true
                                  end
    Gem.configuration.write
  end

end

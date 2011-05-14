class Gem::Commands::AutoCompileCommand < Gem::Command

  def initialize
    super 'auto_compile', 'Enable gem compilation at install time'
  end

  def execute
    # is on?
    #   turn off
    # is off?
    #   turn on
  end

end

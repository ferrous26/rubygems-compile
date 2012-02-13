require 'ripper'

##
# Uses the ripper parser to analyze ruby code contained in gems
# and raises warnings if the code has potential issues.

class Gem::Analyzer < Ripper::SexpBuilder

  ##
  # Cache of issues found for the current session.

  attr_reader :warnings

  def parse
    @warnings = []
    super
  end

  def on_kw token
    # Related to MacRuby ticket #721
    if token == '__FILE__'
      @warnings << '__FILE__ keyword is used (MacRuby ticket #721)'
    end
  end

end

require 'ripper'

##
# Uses the ripper parser to analyze ruby code contained in gems
# and raises warnings if the code has potential issues.

class Gem::Analyzer < Ripper::SexpBuilder

  ##
  # Raised in any case that the given code might display bad
  # behaviours that were not intended.

  class Warning < Exception
  end

  def on_kw token
    # Related to MacRuby ticket #721
    if token == '__FILE__'
      raise Warning, '__FILE__ keyword is used (MacRuby ticket #721)'
    end
  end

end

require 'ripper'

class Gem::Analyzer < Ripper::SexpBuilder

  class Warning < Exception
  end

  def on_kw token
    if token == '__FILE__'
      raise Warning, 'The __FILE__ keyword is used in this file'
    end
  end

end

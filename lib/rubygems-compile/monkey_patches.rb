unless Gem.suffixes.include? '.rbo'
  module Gem
    class << self
      # To get around how rubygems-1.4.2 set's suffixes
      alias_method :rubygems_compile_suffixes, :suffixes
      def suffixes
        ['.rbo'] + rubygems_compile_suffixes
      end
    end
  end
end

require 'rubygems/version_option'
require 'rubygems-compile/common_methods'

class Gem::Commands::UncompileCommand < Gem::Command
  include Gem::VersionOption
  include Gem::CompileMethods

  def initialize
    super 'uncompile', 'Uncompile installed gems',
          ignore: true, all: false

    add_version_option
    add_option(
               '-a', '--all', 'Uncompile all installed gem'
               ) do |all,opts| opts[:all] = all end
    add_option(
               '-I', '--[no-]ignore-dependencies', 'Also uncompile dependencies'
               ) do |value, options| options[:ignore] = value end
  end

  def arguments # :nodoc:
    'GEMNAME          name of the gem to uncompile'
  end

  def defaults_str # :nodoc:
    super + '--ignore-dependencies'
  end

  def usage # :nodoc:
    "#{program_name} GEMNAME [GEMNAME ...]"
  end

  ##
  # Determine which gems need to be uncompiled, then create and run
  # an uncompiler object for each of them.

  def execute
    require 'rubygems-compile/uncompiler'
    uncompiler = Gem::Uncompiler.new
    execution_list.each { |gem| uncompiler.uncompile(gem) }
  end

end

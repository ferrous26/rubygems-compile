require 'rubygems/dependency_list'
require 'rubygems/version_option'
require 'rubygems-compile/common_methods'


##
# Use the MacRuby compiler to compile installed gems.

class Gem::Commands::CompileCommand < Gem::Command
  include Gem::VersionOption
  include Gem::CompileMethods

  def initialize
    super 'compile', 'Compile (or recompile) installed gems',
          ignore: true, all: false

    add_version_option
    add_option(
               '-a', '--all', 'Compile all installed gem'
               ) do |all,opts| opts[:all] = all end
    add_option(
               '-I', '--[no-]ignore-dependencies', 'Also compile dependencies'
               ) do |value, options| options[:ignore] = value end
  end

  def arguments # :nodoc:
    'GEMNAME          name of the gem to compile'
  end

  def defaults_str # :nodoc:
    super + '--ignore-dependencies'
  end

  def usage # :nodoc:
    "#{program_name} GEMNAME [GEMNAME ...]"
  end

  ##
  # Determine which gems need to be compiled, then create and run a compiler
  # object for each of them.

  def execute
    gems = execution_list
    gems.delete_if { |spec| spec.name == 'rubygems-compile' }

    if gems.count >= 10
      alert 'This could take a while...'
    end

    require 'rubygems-compile/compiler'
    gems.each { |gem| Gem::Compiler.compile gem }
  end

end

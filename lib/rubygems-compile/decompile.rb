require 'fileutils'
require 'rubygems/command'
require 'rubygems/commands/install_command'
require 'rubygems-compile/common_methods'

##
# Remove the compiled files for a gem. This is sometimes necessary for
# gems that do not work after being compiled.

class Gem::Commands::CompileCommand < Gem::Commands::InstallCommand
  include Gem::Compile::Methods

  def initialize
    super
    @command = 'decompile'
    @summary = 'Remove compiled *.rbo files for gems, possibily reinstalling'
    @program_name = 'gem decompilecompile'
  end

  ##
  # Lookup the gems and their listed files. It will only compile files
  # that are located in the `require_path` for a gem.

  def execute

    verbose   = Gem.configuration.verbose
    slash     = verbose.is_a?(Fixnum) ? '/' : ''

    get_specs_for_gems(get_all_gem_names).each { |gem|
      say "Decompiling #{gem.name}-#{gem.version}#{slash}" if verbose

      path      = gem.full_gem_path
      files     = find_files_to_compile gem
      reinstall = false

      files.each { |file|
        say "\tRemoving #{file}o" if verbose.is_a? Fixnum
        full_path = "#{path}/#{file}"
        FileUtils.rm( full_path + 'o' )
        reinstall = true unless File.exists? full_path
      }

      super if reinstall
    }

  end

end

Gem::CommandManager.instance.register_command :decompile

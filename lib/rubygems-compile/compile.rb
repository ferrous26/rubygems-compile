require 'rbconfig'
require 'fileutils'
require 'rubygems/command'
require 'rubygems/commands/install_command'
require 'rubygems-compile/common_methods'

##
# Use the MacRuby compiler to compile gems at install time. This
# includes the option to remove the original *.rb files leaving
# only the compiled *.rbo files.

class Gem::Commands::CompileCommand < Gem::Commands::InstallCommand
  include Gem::Compile::Methods

  def initialize
    super # so that InstallCommand options are registered
    @command = 'compile' # now we override certain attributes
    @summary = 'Install and compile gems using the MacRuby compiler'
    @program_name = 'gem compile'

    defaults[:'remove-original-files'] = false
    add_option( '-r', '--[no-]remove-original-files',
                'Delete the original *.rb source files after compiling',
                ) do |value, options|
      options[:'remove-original-files'] = value
    end
  end

  def defaults_str # :nodoc:
    super + "\n--no-remove-original-files"
  end

  ##
  # Lookup the gems and their listed files. It will only compile files
  # that are located in the `require_path` for a gem.

  def execute

    verbose      = Gem.configuration.verbose
    slash        = verbose.is_a?(Fixnum) ? '/' : ''
    post_compile = Proc.new do |_,_| end

    if options[:'remove-original-files']
      post_compile = Proc.new do |file, full_path|
        say "\tRemoving #{file}" if verbose.is_a? Fixnum
        FileUtils.rm full_path
        end
    end

    Gem.post_install do |gem|
      spec = gem.spec
      say "Compiling #{spec.name}-#{spec.version}#{slash}" if verbose

      path  = spec.full_gem_path
      files = find_files_to_compile spec

      files.each { |file|
        say "\t#{file} => #{file}o" if verbose.is_a? Fixnum
        full_path = path + '/' + file
        `#{MACRUBYC} -C '#{full_path}' -o '#{full_path}o'`
        post_compile.call file, full_path
      }
    end

    super
  end

end

Gem::CommandManager.instance.register_command :compile

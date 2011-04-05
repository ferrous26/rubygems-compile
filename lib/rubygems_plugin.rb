require 'rbconfig'
require 'fileutils'
require 'rubygems/command'
require 'rubygems/commands/install_command'

DID_NOT_LOAD_COMPILER_MYSELF   = true
unless Kernel.const_defined? 'Compiler'
  DID_NOT_LOAD_COMPILER_MYSELF = false
  load File.join(RbConfig::CONFIG['bindir'], 'macrubyc')
end

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

##
# Use the MacRuby compiler to compile gems at install time. This
# includes the option to remove the original *.rb files leaving
# only the compiled *.rbo files.

class Gem::Commands::CompileCommand < Gem::Commands::InstallCommand

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

    if DID_NOT_LOAD_COMPILER_MYSELF
      say <<-EOM
This version of MacRuby already does gem compilation!
This rubygems extensions is obsolete, you should uninstall rubygems-compile.
You can just use `macgem install` now.
      EOM
      return
    end

    post_compile = Proc.new { |_| }
    if options[:'remove-original-files']
      post_compile = Proc.new do |file|
        say "\tRemoving #{File.basename(file)}" if Gem.configuration.really_verbose
        FileUtils.rm file
      end
    end

    Gem.post_install do |gem|
      spec = gem.spec

      if Gem.configuration.verbose
        slash = Gem.configuration.really_verbose ? '/' : ''
        say "Compiling #{spec.full_name}#{slash}"
      end

      files = spec.files - spec.test_files - spec.extra_rdoc_files
      files = files.reject do |file| file.match /^(?:test|spec)/ end
      # note: we ignore the .rb.data file in the mime-types gem
      files = files.select do |file| file.match /\.rb$/ end

      files.each { |file|
        say "\t#{file} => #{file}o" if Gem.configuration.really_verbose
        full_path = File.join(spec.full_gem_path, file)
        ::Compiler.new(
                       bundle: true,
                        files: [full_path],
                       output: "#{full_path}o"
                       ).run
        post_compile.call(full_path)
      }
    end

    super
  end

end

Gem::CommandManager.instance.register_command :compile

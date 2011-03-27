require 'rbconfig'
require 'fileutils'
require 'macruby/compiler'
require 'rubygems/command'
require 'rubygems/commands/install_command'

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

    verbose      = Gem.configuration.verbose
    slash        = verbose.is_a?(Fixnum) ? '/' : ''
    post_compile = Proc.new do |_,_| end
    compile_options = { bundle: true }

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
        compile_options.merge! files: [full_path], output: "#{full_path}o"
        Compiler.new( compile_options ).run
        post_compile.call file, full_path
      }
    end

    super
  end

  def get_specs_for_gems gem_names # :nodoc:
    gem_names.flatten.map { |gem|
      Gem.source_index.find_name gem
    }.flatten.compact
  end

  def find_files_to_compile gem # :nodoc:
    files = gem.files - gem.test_files - gem.extra_rdoc_files
    files = files.reject do |file| file.match /^(?:test|spec)/ end
    # this cuts out the .rb.data file in the mime-types gem
    files.select do |file| file.match /\.rb$/ end
  end

end

Gem::CommandManager.instance.register_command :compile

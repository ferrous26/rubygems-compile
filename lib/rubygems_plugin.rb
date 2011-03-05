require 'rubygems/command'
require 'rubygems/commands/install_command'
require 'fileutils'
require 'rbconfig'

##
# Use the MacRuby compiler to compile gems at install time. This
# includes the option to remove the original *.rb files leaving
# only the compiled *.rbo files.

class Gem::Commands::CompileCommand < Gem::Commands::InstallCommand

  MACRUBYC = File.join(RbConfig::CONFIG['bindir'], 'macrubyc')

  def initialize
    super
    @command = 'compile'
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
    begin
      super
    rescue Gem::SystemExitException => e
      raise Gem::SystemExitException, e.message unless e.exit_code.zero?
    end

    verbose      = Gem.configuration.verbose
    slash        = verbose.is_a?(Fixnum) ? '/' : ''
    post_compile = Proc.new do |_,_| end

    if options[:'remove-original-files']
      post_compile = Proc.new do |file, full_path|
        say "\tRemoving #{file}" if verbose.is_a? Fixnum
        FileUtils.rm full_path
      end
    end


    get_specs_for_gems(get_all_gem_names).each { |gem|
      say "Compiling #{gem.name}-#{gem.version}#{slash}" if verbose

      path  = gem.full_gem_path
      files = find_files_to_compile gem

      files.each { |file|
        say "\t#{file} => #{file}o" if verbose.is_a? Fixnum
        full_path = path + '/' + file
        `#{MACRUBYC} -C '#{full_path}' -o '#{full_path}o'`
        post_compile.call file, full_path
      }
    }

  end

  def get_specs_for_gems gem_names # :nodoc:
    gem_names.flatten.map { |gem|
      Gem.source_index.find_name gem
    }.flatten.compact
  end

  def find_files_to_compile gem # :nodoc:
    files = gem.files - gem.test_files - gem.extra_rdoc_files
    files = files.reject do |file| file.match /^(?:test|spec)/ end
    files.select do |file| file.match /\.rb$/ end
  end

end

Gem::CommandManager.instance.register_command :compile

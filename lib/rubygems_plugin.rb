require 'rubygems/command'
require 'rubygems/dependency_installer'

##
# @todo option to replace the original files, which implies removing

class Gem::Commands::CompileCommand < Gem::Command

  def initialize
    defaults = {
      :'remove-original-files' => false,
    }
    super 'compile', 'Compile gems using the MacRuby compiler', defaults

    add_option( '-r', '--[no-]remove-original-files',
                'Delete the original *.rb source files after compiling',
                ) do |value, options|
      options[:'remove-original-files'] = value
    end
  end

  def arguments # :nodoc:
    'GEMNAME       name of gem to compile'
  end

  def defaults_str # :nodoc:
    '--no-remove-original-files'
  end

  def usage # :nodoc:
    "#{program_name} GEMNAME [GEMNAME ...]"
  end

  ##
  # @todo call #install when the gem does not exist
  #
  # Lookup the gems and their listed files. It will only compile files
  # that are located in the `require_path` for a gem.

  def execute

    specs = get_specs_for_gems get_all_gem_names

    if specs.empty?
      message = "Did not find any of: #{get_all_gem_names.join ', '}"
      raise ArgumentError, message
    end

    verbose = Gem.configuration.verbose
    slash   = verbose ? '/' : ''

    specs.each { |gem|
      say "Compiling #{gem.name}-#{gem.version}#{slash}" if verbose

      path  = gem.full_gem_path
      files = find_files_to_compile gem

      files.each { |file|
        say "\t#{file} => #{file}o" if verbose
        full_path = path + '/' + file
        `macrubyc -C '#{full_path}' -o '#{full_path}o'`
      }
      remove_original_files files if options[:'remove-original-files']
    }

  end

  def get_specs_for_gems *gem_names # :nodoc:
    gem_names.map { |gem|
      Gem.source_index.find_name gem
    }.flatten.compact
  end

  def find_files_to_compile gem # :nodoc:
    files = gem.files - gem.test_files - gem.extra_rdoc_files
    files = files.reject do |file| file.match /^(?:test|spec)/ end
    files.select do |file| file.match /\.rb$/ end
  end

  def remove_original_files # :nodoc:
    # @todo use fileutils or is there a rubygems way?
    say 'removing original *.rb file now' if verbose
    raise NotImplementedError
  end

end

Gem::CommandManager.instance.register_command :compile

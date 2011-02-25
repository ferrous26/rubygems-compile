require 'rubygems/command'
require 'rubygems/dependency_installer'

class Gem::Commands::CompileCommand < Gem::Command

  def initialize
    super 'compile', 'Compile gems using the MacRuby compiler', :'remove-original-files' => false

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
  # Lookup the gems and their listed files. It will only compile files
  # that are located in the `require_path` for a gem.

  def execute
    specs = get_all_gem_names.map { |gem|
      Gem.source_index.find_name gem
    }.flatten.compact

    if specs.empty?
      message = "Did not find any of: #{get_all_gem_names.join ', '}"
      raise ArgumentError, message
    end

    specs.each { |gem|
      puts "Compiling #{gem.name}-#{gem.version}/"

      lib_dirs  = Gem.searcher.lib_dirs_for gem
      dirs      = Dir.glob lib_dirs
      files     = dirs.map { |dir| Dir.glob( dir + '/**/*.rb' ) }.flatten
      pp_regexp = Regexp.union dirs.map { |dir| dir.sub File.basename(dir), '' }

      files.each { |file|
        pp_file = file.sub pp_regexp, ''
        puts "\t#{pp_file} => #{pp_file}o"

        # @todo double check to see how macruby_deploy calls the compiler
        `macrubyc -C '#{file}' -o '#{file}o'`
        # @todo actually remove the file after I write some tests
        puts 'removing original *.rb file now' if options[:'remove-original-files']
      }
    }

  end

end

Gem::CommandManager.instance.register_command :compile

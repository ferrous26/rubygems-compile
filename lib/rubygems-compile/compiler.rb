class Gem::Compiler
  include Gem::UserInteraction

  def initialize
    @current_directory = []
    @config            = Gem.configuration
  end

  def call gem
    @spec = gem.is_a?(Gem::Specification) ? gem : gem.spec

    if @spec.name == 'rubygems-compile'
      alert_info 'You cannot compile rubygems-compile' if @config.really_verbose
      return
    end

    say compilation_message if @config.verbose

    gem_files.each do |file|
      say compile_file_msg(file) if @config.really_verbose
      absolute_file_path = File.join(@spec.full_gem_path, file)
      MacRuby::Compiler.new(
                            bundle: true,
                            output: "#{absolute_file_path}o",
                             files: [absolute_file_path]
                            ).run
    end
  end

  alias_method :compile, :call

  def compilation_message
    slash = @config.really_verbose ? '/' : ''
    "Compiling #{@spec.full_name}#{slash}"
  end

  ##
  # --
  # TODO Get better at deciding which files to compile; right now we
  #      ignore the .rb.data file in the mime-types gem and probably
  #      some other silly edge cases that are similar.
  # ++
  #
  # We want to find all the files in a gem to compile, but avoid compiling
  # test files and other misc. files which are usually found in the top
  # level or test directory.
  #

  def gem_files
    @spec.lib_files
    # files = @spec.files - @spec.test_files - @spec.extra_rdoc_files
    # files.reject { |file| file.match /^(?:test|spec)/ }
    #   .select { |file| file.match /\.rb$/ }
  end

  def compile_file_msg file
    name = File.basename(file)
    dirs = file.chomp(name).split(File::SEPARATOR)
    tabs = "\t" * dirs.count

    dirs.each_with_index do |dir, index|
      unless @current_directory[index] == dir
        @current_directory[index] = dir
        say( "\t" * (index + 1) + dir + File::SEPARATOR)
      end
    end

    "#{tabs}#{name} => #{name}o"
  end

end

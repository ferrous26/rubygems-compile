class Gem::Compiler
  include Gem::UserInteraction

  def initialize
    require 'rbconfig'
    unless MacRuby.const_defined?(:Compiler)
      load File.join(RbConfig::CONFIG['bindir'], 'macrubyc')
    end
    require 'rubygems-compile/analyzer'

    @current_directory = []
    @config            = Gem.configuration
  end

  def call gem
    @spec = gem.is_a?(Gem::Specification) ? gem : gem.spec

    if @spec.name == 'rubygems-compile'
      alert_info 'You cannot compile rubygems-compile' if really_verbose
      return
    end

    say compilation_message if verbose

    gem_files.each do |file|
      message            = compile_file_msg(file)
      absolute_file_path = File.join(@spec.full_gem_path, file)
      if warning = unsafe?(absolute_file_path)
        message << "\t\t\tSKIPPED: #{warning.message}"
      else
        MacRuby::Compiler.new(
                              bundle: true,
                              output: "#{absolute_file_path}o",
                               files: [absolute_file_path]
                              ).run
      end
      say message if really_verbose
    end
  end
  alias_method :compile, :call

  ##
  # Uses the GemAnalyzer class to determine if a given file might have
  # any potential issues when compiled.

  def unsafe? file
    Gem::Analyzer.new(File.read(file)).parse
    false
  rescue Gem::Analyzer::Warning => e
    e
  end

  def compilation_message
    slash = really_verbose ? '/' : ''
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
    @spec.lib_files.select { |file| File.extname(file) == '.rb' }
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
        say( "\t" * (index + 1) + dir + File::SEPARATOR) if really_verbose
      end
    end

    "#{tabs}#{name} => #{name}o"
  end

  def verbose
    @config.verbose
  end

  def really_verbose
    @config.really_verbose
  end

end

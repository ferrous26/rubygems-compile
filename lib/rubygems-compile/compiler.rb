class Gem::Compiler
  include Gem::UserInteraction

  class << self
    def compile gem
      @instance ||= Gem::Compiler.new
      @instance.compile gem
    end
    alias_method :call, :compile
  end

  def initialize
    require 'rbconfig'
    unless MacRuby.const_defined?(:Compiler)
      load File.join(RbConfig::CONFIG['bindir'], 'macrubyc')
    end
    require 'rubygems-compile/analyzer'

    @current_directory = []
    @config            = Gem.configuration
  end

  def compile gem
    @spec = gem.is_a?(Gem::Specification) ? gem : gem.spec

    return if trying_to_compile_self?
    say gem_compilation_message if verbose

    gem_files.each do |file|
      message   = compile_file_message(file)
      full_path = File.join(@spec.full_gem_path, file)
      if unsafe? full_path
        message << "\t\t\tSKIPPED: #{@parser.warnings.join(', ')}"
      else
        MacRuby::Compiler.compile_file full_path
      end
      say message if really_verbose
    end
  end

  ##
  # Uses the GemAnalyzer class to determine if a given file might have
  # any potential issues when compiled.

  def unsafe? file
    @parser = Gem::Analyzer.check File.read(file)
    !@parser.warnings.empty?
  end

  def gem_compilation_message
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

  if Gem::VERSION.to_f < 1.8
    def gem_files
      @spec.lib_files.select { |file| File.extname(file) == '.rb' }
    end
  else
    def gem_files
      Dir.glob("#{@spec.lib_dirs_glob}/**/*.rb").map { |file|
        file.sub(Regexp.new(Regexp.escape(@spec.full_gem_path)), '')
      }
    end
  end

  def compile_file_message file
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

  def trying_to_compile_self?
    if @spec.name == 'rubygems-compile'
      alert 'You cannot compile rubygems-compile' if really_verbose
      true
    end
  end

end

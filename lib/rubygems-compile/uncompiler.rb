class Gem::Uncompiler
  include Gem::UserInteraction

  def initialize
    @current_directory = []
    @config            = Gem.configuration
  end

  def uncompile gem
    @spec = gem.is_a?(Gem::Specification) ? gem : gem.spec

    say uncompilation_message if @config.verbose

    gem_files.each do |file|
      say uncompile_file_msg(file) if @config.really_verbose
      absolute_file_path = File.join(@spec.full_gem_path, file)
      FileUtils.rm file
    end
  end

  def uncompilation_message
    slash = @config.really_verbose ? '/' : ''
    "Uncompiling #{@spec.full_name}#{slash}"
  end

  def gem_files
    @spec.files.select { |file| File.extname(file) == '.rbo' }
  end

  def uncompile_file_msg file
    name = File.basename(file)
    dirs = file.chomp(name).split(File::SEPARATOR)
    tabs = "\t" * dirs.count

    dirs.each_with_index do |dir, index|
      unless @current_directory[index] == dir
        @current_directory[index] = dir
        say( "\t" * (index + 1) + dir + File::SEPARATOR)
      end
    end

    "Removing #{tabs}#{name}"
  end

end

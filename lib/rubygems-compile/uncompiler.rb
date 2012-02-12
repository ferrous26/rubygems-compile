class Gem::Uncompiler
  include Gem::UserInteraction

  def self.uncompile gem
    @instance ||= Gem::Uncompiler.new
    @instance.uncompile gem
  end

  def initialize
    require 'fileutils'
    @config = Gem.configuration
  end

  def uncompile gem
    @spec = gem.is_a?(Gem::Specification) ? gem : gem.spec

    say uncompilation_message if @config.verbose

    gem_files.each do |file|
      absolute_file_path = File.join(@spec.full_gem_path, file)
      FileUtils.rm absolute_file_path
      say "\tAsploded #{file}" if @config.really_verbose
    end
  end

  def uncompilation_message
    slash = @config.really_verbose ? '/' : ''
    "Uncompiling #{@spec.full_name}#{slash}"
  end

  def gem_files
    Dir.glob(File.join(@spec.full_gem_path, '**','*.rbo')).map do |file|
      file.sub /#{@spec.full_gem_path}\//, ''
    end
  end

end

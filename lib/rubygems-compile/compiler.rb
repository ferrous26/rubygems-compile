module Gem
  class Compiler
    def initialize
      # the path to the current file, split by File::SEPARATOR
      @current_directory = []
    end

    def call gem
      @ui     ||= Gem::UserInteraction.new
      @config   = Gem.configuration
      @spec     = gem.spec

      if @spec.name == 'rubygems-compile'
        @ui.alert 'You cannot compile rubygems-compile'
        return
      end

      @ui.say compilation_message if @config.verbose

      gem_files.each do |file|
        @ui.say compile_file_msg(file) if @config.really_verbose
        absolute_file_path = File.join(@spec.full_gem_path, file)
        Compiler.new(
                     bundle: true,
                     files: [absolute_file_path],
                     output: "#{absolute_file_path}o"
                     ).run
      end
    end

    def compilation_message
      slash = @config.really_verbose ? '/' : ''
      "Compiling #{@spec.full_name}#{slash}"
    end

    # @todo get better at deciding which files to compile;
    #       right now we ignore the .rb.data file in the mime-types gem
    #       and probably some other silly edge cases that are similar
    def gem_files
      files = @spec.files - @spec.test_files - @spec.extra_rdoc_files
      files.reject { |file| file.match /^(?:test|spec)/ }
        .select { |file| file.match /\.rb$/ }
    end

    def compile_file_msg file
      name = File.basename(file)
      dirs = file.chomp(name).split(File::SEPARATOR)
      tabs = "\t" * dirs.count

      dirs.each_with_index do |dir, index|
        unless @current_directory[index] == dir
          @current_directory[index] = dir
          @ui.say( "\t" * (index + 1) + dir + File::SEPARATOR)
        end
      end

      "#{tabs}#{name} => #{name}o"
    end

  end
end

require 'rubygems/dependency_list'

##
# Use the MacRuby compiler to compile installed gems.

class Gem::Commands::CompileCommand < Gem::Command
  # include Gem::VersionOption

  def initialize
    super 'compile', 'Compile (or recompile) an installed gem',
          ignore: true, all: false

    # add_version_option
    add_option(
               '-a', '--all', 'Compile all installed gem'
               ) do |all,opts| opts[:all] = all end
    add_option(
               '-I', '--[no-]ignore-dependencies', 'Also compile dependencies'
               ) do |value, options| options[:ignore] = value end
  end

  def arguments # :nodoc:
    'GEMNAME          name of the gem to compile'
  end

  def defaults_str # :nodoc:
    super + '--ignore-dependencies'
  end

  def usage # :nodoc:
    "#{program_name} GEMNAME [GEMNAME ...]"
  end

  ##
  # Determine which gems need to be compiled, then create and run a compiler
  # object for each of them.

  def execute
    installed_gems = Gem.source_index.all_gems

    gem_names = if options[:all] then
                  installed_gems.map { |_, spec| spec.name } - ['rubygems-compile']
                else
                  get_all_gem_names
                end

    gems_to_compile = gem_names.map do |gem|
      candidates = Gem.source_index.find_name(gem)

      if candidates.empty?
        alert_error "#{gem} is not installed. Skipping."
        next
      end

      candidates << dependencies_for(*candidates) unless options[:ignore]
      candidates
    end.flatten.uniq

    if gems_to_compile.count >= 10
      alert 'This could take a while; you might want to take a coffee break'
    end

    compiler = Gem::Compiler.new
    gems_to_compile.each { |gem| compiler.compile(gem) }
  end

end

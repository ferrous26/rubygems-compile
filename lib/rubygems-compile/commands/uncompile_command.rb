class Gem::Commands::UncompileCommand < Gem::Command
  include Gem::VersionOption
  include Gem::SimpleDepList

  def initialize
    super 'uncompile', 'Uncompile installed gems',
          ignore: true, all: false

    add_version_option
    add_option(
               '-a', '--all', 'Uncompile all installed gem'
               ) do |all,opts| opts[:all] = all end
    add_option(
               '-I', '--[no-]ignore-dependencies', 'Also uncompile dependencies'
               ) do |value, options| options[:ignore] = value end
  end

  def arguments # :nodoc:
    'GEMNAME          name of the gem to uncompile'
  end

  def defaults_str # :nodoc:
    super + '--ignore-dependencies'
  end

  def usage # :nodoc:
    "#{program_name} GEMNAME [GEMNAME ...]"
  end

  ##
  # Determine which gems need to be uncompiled, then create and run
  # an uncompiler object for each of them.

  def execute
    installed_gems = Gem.source_index.all_gems

    gem_names = if options[:all] then
                  installed_gems.map { |_, spec| spec.name }
                else
                  get_all_gem_names
                end

    gems_to_uncompile = gem_names.map do |gem|
      candidates = Gem.source_index.find_name(gem)

      if candidates.empty?
        alert_error "#{gem} is not installed. Skipping."
        next
      end

      candidates << dependencies_for(*candidates) unless options[:ignore]
      candidates
    end.flatten.uniq

    uncompiler = Gem::Uncompiler.new
    gems_to_uncompile.each { |gem| uncompiler.uncompile(gem) }
  end

end

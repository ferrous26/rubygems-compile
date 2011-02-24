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

  def execute
    puts options.inspect
  end

end

Gem::CommandManager.instance.register_command :compile


Gem.post_install do |gem|

  # @todo read option from .gemrc that would disable this hook

  spec  = gem.spec
  dir   = gem.gem_home + '/gems/' + spec.name + '-' + spec.version.version

  files = spec.files - spec.test_files - spec.extra_rdoc_files
  files = files.reject { |file| file.match /^(?:test|spec)/ }

  files.each do |file|
    next unless file.match /\.rb$/
    puts "Compiling #{file} to #{file}o"
    file = "#{dir}/#{file}"
    `macrubyc -C '#{file}' -o '#{file}o'`
  end

end

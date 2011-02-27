require 'rubygems'
require 'rake'

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :'gem:build'

namespace :macruby do
  desc 'AOT compile'
  task :compile do
    FileList["lib/**/*.rb"].each do |source|
      name = File.basename source
      puts "#{name} => #{name}o"
      `macrubyc --arch x86_64 -C '#{source}' -o '#{source}o'`
    end
  end

  desc 'Clean MacRuby binaries'
  task :clean do
    FileList["lib/**/*.rbo"].each do |bin|
      rm bin
    end
  end
end

namespace :gem do
  desc 'Build the gem'
  task :build do
    puts `gem build -v rubygems-compile.gemspec`
  end

  desc 'Build the gem and install it'
  task :install => :build do
    puts `gem install #{Dir.glob('rubygems-compile*.gem').sort.reverse.first}`
  end
end

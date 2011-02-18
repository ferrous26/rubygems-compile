require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

# require 'rake/testtask'
# Rake::TestTask.new(:test) do |test|
#   test.libs << 'lib' << 'test'
#   test.pattern = 'test/**/test_*.rb'
#   test.verbose = true
# end

# require 'rcov/rcovtask'
# Rcov::RcovTask.new do |test|
#   test.libs << 'test'
#   test.pattern = 'test/**/test_*.rb'
#   test.verbose = true
# end

task :default => :test

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


require 'rubygems'
require 'rake'

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

namespace :macruby do
  require 'rake/compiletask'
  Rake::CompileTask.new do |t|
    t.files   = FileList["lib/**/*.rb"]
    t.verbose = true
  end

  desc 'Clean MacRuby binaries'
  task :clean do
    FileList["lib/**/*.rbo"].each do |bin|
      rm bin
    end
  end
end

namespace :gem do
  require 'rubygems/builder'
  require 'rubygems/installer'
  spec = Gem::Specification.load('rubygems-compile.gemspec')

  desc 'Build the gem'
  task :build do Gem::Builder.new(spec).build end

  desc 'Build the gem and install it'
  task :install => :build do Gem::Installer.new(spec.file_name).install end
end

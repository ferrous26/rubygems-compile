require 'rake/testtask'
require 'rake/gempackagetask'
require 'rubygems/dependency_installer'

task :default => :gem

Rake::TestTask.new(:test) do |test|
  test.libs     << 'lib' << 'test'
  test.pattern   = 'test/**/test_*.rb'
  test.verbose   = true
  test.ruby_opts = ['-rhelper']
end

eval IO.read('rubygems-compile.gemspec')

Rake::GemPackageTask.new(GEM_SPEC) do |pkg|
  pkg.need_zip = false
  pkg.need_tar = true
end

desc 'Build the gem and install it'
task :install => :gem do
  Gem::Installer.new("pkg/#{GEM_SPEC.file_name}").install
end

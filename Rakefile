task :default => :gem

require 'rake/testtask'
Rake::TestTask.new do |test|
  test.libs     << 'test'
  test.pattern   = 'test/**/test_*.rb'
  test.verbose   = true
  test.ruby_opts = ['-rhelper']
end

require 'rubygems'
spec = Gem::Specification.load('rubygems-compile.gemspec')

require 'rake/gempackagetask'
Rake::GemPackageTask.new(spec) { }

require 'rubygems/dependency_installer'
desc 'Build the gem and install it'
task :install => :gem do
  Gem::Installer.new("pkg/#{spec.file_name}").install
end

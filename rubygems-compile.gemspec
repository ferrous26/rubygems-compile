Gem::Specification.new do |s|
  s.name    = 'rubygems-compile'
  s.version = '0.1.0'

  s.required_rubygems_version = Gem::Requirement.new '>= 1.4.2'
  s.rubygems_version          = Gem::VERSION

  s.summary       = 'A rubygems post-install hook using the MacRuby compiler to compile gems'
  s.description   = <<-EOS
A rubygems post-install hook to compile gems using the MacRuby compiler.
  EOS
  s.post_install_message = <<-EOS

***********************************************************
Make sure to uninstall versions of rubygems-compile prior
to 0.1.0 or you will end up compiling your gems multiple
times.
***********************************************************

  EOS
  s.authors       = ['Mark Rada']
  s.email         = 'mrada@marketcircle.com'
  s.homepage      = 'http://github.com/ferrous26/rubygems-compile'
  s.licenses      = ['MIT']
  s.has_rdoc      = true
  s.require_paths = ['lib']

  s.files            = Dir.glob('lib/**/*.rb')
  s.test_files       = Dir.glob('test/**/test_*.rb') + ['test/helper.rb']
  s.extra_rdoc_files = [ 'Rakefile', 'LICENSE.txt', 'README.rdoc' ]

  s.add_development_dependency 'minitest', ['>= 2.0.2']
end

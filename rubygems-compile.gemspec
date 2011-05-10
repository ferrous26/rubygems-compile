Gem::Specification.new do |s|
  s.name    = 'rubygems-compile'
  s.version = '0.3.0'

  s.required_rubygems_version = Gem::Requirement.new '>= 1.4.2'
  s.rubygems_version          = Gem::VERSION

  s.summary       = 'A rubygems post-install hook using the MacRuby compiler to compile gems'
  s.description   = <<-EOS
A rubygems post-install hook to compile gems using the MacRuby compiler.
  EOS
  s.post_install_message = <<-EOS

***********************************************************

Please uninstall previous versions of this gem, or else
rubygems will try to load each version of the gem.

The functionality of this gem has changed since the 0.0.x
series. It now operates as its own command, see the README.

https://github.com/ferrous26/rubygems-compile

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

  s.add_development_dependency 'minitest-macruby-pride', ['>= 2.2.0']
end

Gem::Specification.new do |s|
  s.name     = 'rubygems-compile'
  s.version  = '1.1.2'
  s.platform = Gem::Platform::MACRUBY

  s.summary       = 'A trio of rubygems commands that interface with the MacRuby compiler'
  s.description   = <<-EOS
A trio of rubygems commands that interface with the MacRuby compiler.
  EOS
  s.post_install_message = <<-EOS

***********************************************************

Please uninstall previous versions of this gem, or else
rubygems will try to load each version of the gem.

This version of rubygems-compile requires MacRuby 0.11 or
newer; the functionality has changed significantly since
pre-1.0 releases, see the README:

    https://github.com/ferrous26/rubygems-compile

***********************************************************

  EOS
  s.authors       = ['Mark Rada']
  s.email         = 'mrada@marketcircle.com'
  s.homepage      = 'http://github.com/ferrous26/rubygems-compile'
  s.licenses      = ['MIT']

  s.files            = Dir.glob('lib/**/*.rb')
  s.test_files       = Dir.glob('test/**/*') + ['Rakefile', '.gemtest']
  s.extra_rdoc_files = ['LICENSE.txt', 'README.markdown']

  s.add_development_dependency 'minitest', '~> 2.11'
end

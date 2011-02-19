# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name    = 'rubygems-compile'
  s.version = '0.0.3'

  s.required_rubygems_version = '>= 1.4.2'
  s.rubygems_version          = '1.4.2'

  s.summary       = 'A rubygems post-install hook using the MacRuby compiler to compile gems'
  s.description   = <<-EOS
A rubygems post-install hook to compile gems using the MacRuby compiler.
  EOS
  s.post_install_message = <<-EOS

***********************************************************
Make sure to uninstall earlier versions of rubygems-compile
or you will end up compiling your gems multiple times.
***********************************************************

  EOS
  s.authors       = ['Mark Rada']
  s.email         = 'mrada@marketcircle.com'
  s.homepage      = 'http://github.com/ferrous26/rubygems-compile'
  s.licenses      = ['MIT']
  s.has_rdoc      = true
  s.require_paths = ['lib']

  s.files            = Dir.glob('lib/**/*.rb')
#  s.test_files       = Dir.glob('test/**/*_test.rb') + ['test/helper.rb']
  s.extra_rdoc_files = [ 'LICENSE.txt', 'README.rdoc' ]

  s.add_development_dependency 'rake',      ['~> 0.8.7']
end

# -*- encoding: utf-8 -*-
$:.unshift(File.expand_path('../lib', __FILE__))
require 'proxylocal/version'

Gem::Specification.new do |s|
  s.name        = 'proxylocal'
  s.version     = ProxyLocal::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Sergey Nartimov']
  s.email       = ['just.lest@gmail.com']
  s.homepage    = 'http://proxylocal.com/'
  s.summary     = 'Proxy your local web-server and make it publicly available over the internet'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }

  s.add_dependency('eventmachine', '>= 0.12.10')
  s.add_dependency('bert', '>= 1.1.2')
  s.add_development_dependency('bundler', '>= 1.0.10')
  s.add_development_dependency('rake', '>= 0.8.7')
end

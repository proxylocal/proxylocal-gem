require 'rubygems'
require 'rake'
require 'echoe'

require 'lib/client'

Echoe.new('proxylocal', ProxyLocal::VERSION) do |p|
  p.summary = 'Proxy your local web-server and make it publicly available over the internet'
  p.url     = 'http://proxylocal.com/'
  p.author  = 'Just Lest'
  p.email   = 'just.lest@gmail.com'
  p.runtime_dependencies = ['eventmachine >=0.12.10', 'bert >=1.1.2']
  p.require_signed = true
  p.project = nil
end

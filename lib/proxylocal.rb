require 'proxylocal/version'

module ProxyLocal
  autoload :Client, 'proxylocal/client'
  autoload :Protocol, 'proxylocal/protocol'
  autoload :ClientProxy, 'proxylocal/client_proxy'
  autoload :Serializer, 'proxylocal/serializer'
  autoload :Command, 'proxylocal/command'

  class << self
    def logger
      @@logger ||= nil
    end

    def logger=(logger)
      @@logger = logger
    end
  end
end

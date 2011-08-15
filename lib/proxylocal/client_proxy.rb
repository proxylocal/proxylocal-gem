require 'eventmachine'

module ProxyLocal
  class ClientProxy < EventMachine::Connection
    def post_init
      @callbacks = {}
    end

    def receive_data(data)
      @callbacks[:on_data].call(data) if @callbacks.has_key?(:on_data)
    end

    def unbind
      @callbacks[:on_unbind].call if @callbacks.has_key?(:on_unbind)
    end

    def on_data(&block)
      @callbacks[:on_data] = block
    end

    def on_unbind(&block)
      @callbacks[:on_unbind] = block
    end
  end
end

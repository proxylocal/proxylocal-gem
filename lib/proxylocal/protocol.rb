require 'bert'
require 'eventmachine'

module ProxyLocal
  module Protocol
    include EventMachine::Protocols::ObjectProtocol

    def serializer
      Serializer
    end

    def receive_object(object)
      object = [object] unless object.is_a?(Array)

      command, *args = object

      method_name = "receive_#{command}"

      if respond_to?(method_name) && [-1, args.size].include?(method(method_name).arity)
        send(method_name, *args)
      else
        receive_unknown(object)
      end
    end

    def send_object(*args)
      object = if args.size > 1
                 BERT::Tuple[*args]
               else
                 args.first
               end
      super(object)
    end
  end
end

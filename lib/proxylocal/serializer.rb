require 'bert'

module ProxyLocal
  module Serializer
    def self.dump(object)
      BERT.encode(object)
    end

    def self.load(data)
      BERT.decode(data)
    end
  end
end

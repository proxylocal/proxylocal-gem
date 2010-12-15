require 'logger'
require 'rubygems'
require 'eventmachine'
require 'bert'

module ProxyLocal
  VERSION = '0.2.2'

  module Serializer
    def self.dump(object)
      BERT.encode(object)
    end

    def self.load(data)
      BERT.decode(data)
    end
  end

  class Client < EventMachine::Connection
    include EventMachine::Protocols::ObjectProtocol

    def self.run(options = {})
      @@logger = Logger.new(STDOUT)
      @@logger.level = options[:verbose] ? Logger::INFO : Logger::WARN

      @@logger.info("Run with options #{options.inspect}")

      trap "SIGCLD", "IGNORE"
      trap "INT" do
        puts
        EventMachine.run
        exit
      end

      EventMachine.run do
        EventMachine.connect(options[:server_host], options[:server_port], self) do |c|
          c.instance_eval do
            @options = options
            if @options[:tls]
              @@logger.info("Request TLS")
              send_object(:start_tls)
            else
              send_options
            end
          end
        end
      end
    end

    def serializer
      Serializer
    end

    def send_options
      send_object(BERT::Tuple[:options, @options])
    end

    def post_init
      @connections = {}
    end

    def ssl_handshake_completed
      send_options
    end

    def first_line(data)
      data.split(/\r?\n/, 2).first
    end

    def receive_object(message)
      message = [message] unless message.is_a?(Array)

      case message[0]
      when :start_tls
        @@logger.info("Start TLS")
        start_tls
      when :message
        puts message[1]
      when :halt
        EventMachine.stop_event_loop
      when :connection
        _, id = message
        @@logger.info("New connection")
        connection = EventMachine.connect('127.0.0.1', @options[:local_port], ClientProxy)
        connection.on_data do |data|
          send_object(BERT::Tuple[:stream, id, data])
        end
        connection.on_unbind do
          @@logger.info("Connection closed")
          @connections.delete(id)
          send_object(BERT::Tuple[:close, id])
        end
        @connections[id] = connection
      when :stream
        _, id, data = message
        @connections[id].send_data(data)
      when :close
        _, id = message
        connection = @connections.delete(id)
        connection.close_connection_after_writing if connection
      else
        @@logger.info("Received #{message.inspect}")
      end
    end

    def unbind
      EventMachine.stop_event_loop
      puts "A connection has been terminated"
    end
  end

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

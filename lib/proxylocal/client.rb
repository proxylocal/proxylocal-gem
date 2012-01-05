require 'logger'
require 'eventmachine'

module ProxyLocal
  class Client < EventMachine::Connection
    include Protocol

    def self.run(options = {})
      @@logger = Logger.new(STDOUT)
      @@logger.level = options[:verbose] ? Logger::INFO : Logger::WARN

      @@logger.info("Run with options #{options.inspect}")

      begin
        trap 'SIGCLD', 'IGNORE'
        trap 'INT' do
          puts
          EventMachine.stop
          exit
        end
      rescue ArgumentError
      end

      EventMachine.run { connect(options) }
    end

    def self.connect(options)
      EventMachine.connect(options[:server_host], options[:server_port], self, options)
    end

    def initialize(options)
      @options = options

      @reconnect = options[:hosts].any?
    end

    def send_options
      send_object(:options, @options)
    end

    def post_init
      @connections = {}

      if @options[:tls]
        @@logger.info('Request TLS')
        send_object(:start_tls)
      else
        send_options
      end
    end

    def ssl_handshake_completed
      send_options
    end

    def unbind
      if @reconnect
        puts "Connection has been terminated. Trying to reconnect..."
        EventMachine.add_timer 5 do
          self.class.connect(@options)
        end
      else
        EventMachine.stop_event_loop
        puts "Connection has been terminated"
      end
    end

    def receive_unknown(object)
      @@logger.info("Received #{object.inspect}")
    end

    def receive_start_tls
      @@logger.info('Start TLS')
      start_tls
    end

    def receive_message(message)
      puts message
    end

    def receive_halt
      @reconnect = false
      EventMachine.stop_event_loop
    end

    def receive_connection(id)
      @@logger.info('New connection')
      connection = EventMachine.connect('127.0.0.1', @options[:local_port], ClientProxy)
      connection.on_data do |data|
        send_object(:stream, id, data)
      end
      connection.on_unbind do
        @@logger.info('Connection closed')
        @connections.delete(id)
        send_object(:close, id)
      end
      @connections[id] = connection
    end

    def receive_stream(id, data)
      @connections[id].send_data(data) if @connections[id]
    end

    def receive_close(id)
      connection = @connections.delete(id)
      connection.close_connection_after_writing if connection
    end
  end
end

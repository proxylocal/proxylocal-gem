require 'rubygems'
require 'optparse'
require 'yaml'

proxylocal_path = File.expand_path('../../lib', __FILE__)
$:.unshift(proxylocal_path) if File.directory?(proxylocal_path) && !$:.include?(proxylocal_path)

require 'proxylocal'

rc_path = File.expand_path(File.join('~', '.proxylocalrc'))
rc = YAML.load_file(rc_path) rescue {}

options = rc.dup

begin
  cmd_args = OptionParser.new do |opts|
    opts.banner = 'Usage: proxylocal [options] [PORT]'

    opts.on('--token TOKEN', 'Save token to .proxylocalrc') do |token|
      rc[:token] = token
      File.open(rc_path, 'w') { |f| f.write(YAML.dump(rc)) }
      File.chmod(0600, rc_path)
      puts 'Token was successfully saved'
      exit
    end

    opts.on('--host HOST', 'Bind to host') do |host|
      options[:hosts] ||= []
      options[:hosts] << host
    end

    opts.on('--ip IP', 'Local IP forward destination address') do |ip|
      options[:ip] = ip
    end

    opts.on('--[no-]tls', 'Use TLS') do |tls|
      options[:tls] = tls
    end

    opts.on('-s', '--server SERVER', 'Specify proxylocal server') do |s|
      options[:server_host], options[:server_port] = s.split(':')
    end

    opts.on('-v', '--[no-]verbose', 'Run verbosely') do |v|
      options[:verbose] = v
    end

    opts.on_tail("--version", "Show version") do
      puts ProxyLocal::VERSION
      exit
    end

    opts.on_tail('-h', '--help', 'Show this message') do
      puts opts
      exit
    end
  end.parse!
rescue OptionParser::MissingArgument => e
  puts e
  exit
rescue OptionParser::InvalidOption => e
  puts e
  exit
end

options[:local_port] = cmd_args[0]
options[:version] = ProxyLocal::VERSION
options.delete_if { |k, v| v.nil? }

default_options = {
  :server_host => 'proxylocal.com',
  :server_port => '8282',
  :local_port => '80',
  :ip => "127.0.0.1",
  :tls => false,
  :verbose => false
}

ProxyLocal::Client.run(default_options.merge(options))

require 'sinatra/base'

module Sinatra
  class Application < Base

    set :app_file, caller_files.first || $0

    set :run, true

    if run? && ARGV.any?
      require 'trollop'


      require 'optparse'
      OptionParser.new { |op|
        op.on('-p port',   'set the port (default is 4567)')                { |val| set :port, Integer(val) }
        op.on('-o addr',   "set the host (default is #{bind})")             { |val| set :bind, val }
        op.on('-e env',    'set the environment (default is development)')  { |val| set :environment, val.to_sym }
        op.on('-s server', 'specify rack server/handler (default is thin)') { |val| set :server, val }
        op.on('-x',        'turn on the mutex lock (default is off)')       {       set :lock, true }
      }.parse!(ARGV.dup)
    end
  end

  at_exit { Application.run! if $!.nil? && Application.run? }
end

extend Sinatra::Delegator

class Rack::Builder
  include Sinatra::Delegator
end

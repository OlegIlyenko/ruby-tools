require 'sinatra/base'
require 'sinatra/content_for'
require 'pathname'
require 'server_support'

module Sinatra
  class Application < Base

    set :app_file, caller_files.first || $0
    set :run, true

    helpers Sinatra::ContentFor

    set :views, Proc.new { File.join(root, "../web/views") }
    set :public_folder, Proc.new { File.join(root, "../web/public") }
    set :opts, nil
    set :description, nil
    set :suffix, nil
    set :remaining_opts, nil
  end
  
  at_exit do
    Application.instance_exec do
      if run? && ARGV.any?
        require 'optparse'
        
        rest = OptionParser.new { |op|
          op.banner = "#{description? ? description + "\n\n" : ''}" +
              "Usage: #{Pathname.new($0).basename} [options] #{suffix? ? suffix + "\n\n" : ''}\n\n" +
              "Options:"
          
          op.on('-p', '--port port',   'set the port (default is 4567)')                { |val| set :port, Integer(val) }
          op.on('-o', '--ohost addr',   "set the host (default is #{bind})")             { |val| set :bind, val }
          op.on('-e env',    'set the environment (default is development)')  { |val| set :environment, val.to_sym }
          op.on('-s server', 'specify rack server/handler (default is thin)') { |val| set :server, val }
          op.on('-x',        'turn on the mutex lock (default is off)')       {       set :lock, true }
          op.on('-b', '--no-browser', "Don't open the browseropen browser")   {       set :browser, true }

          opts[op]
        }.parse!(ARGV.dup)
        
        if remaining_opts?
          remaining_opts[rest]
        end
      end

      run! if $!.nil? && run?
      
      Server.open_browser(self, browser)
    end
  end
end

module Sinatra
  module Delegator
    def options &block
      set :opts, -> {block}
    end

    def remaining_options &block
      set :remaining_opts, -> {block}
    end
  end
end

extend Sinatra::Delegator

class Rack::Builder
  include Sinatra::Delegator
end
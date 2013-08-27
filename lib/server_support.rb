require 'sinatra/base'
require 'launchy'
require 'rack'
require 'coffee_script'
require 'less'

module Server
  Assets = Sinatra.new do
      set :views, Proc.new { File.join(root, "../web/assets") }
  
      get '/assets/*/*.*' do
        _, path, type = params[:splat]
        full_path = :"#{path}"
  
        case type
          when 'js' then coffee full_path
          when 'css' then less full_path
          else pass
        end
      end
  end

  def self.reload ctx
    ctx.instance_exec do
      Sinatra::Application.reset!
      use Rack::Reloader, 0
    end
  end
  
  def self.open_browser ctx, no_browser
    unless no_browser
      ctx.instance_exec {Launchy.open("http://localhost:#{settings.port}")}
    end
  end

  def self.thread
    Thread.new do
      begin
        yield
      rescue Exception => e
        $stderr.puts "Error: " + e.message
        $stderr.puts e.backtrace.join("\n")
      end
    end
  end
end
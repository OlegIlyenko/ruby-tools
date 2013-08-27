require 'sinatra/base'
require 'sinatra/content_for'
require 'rack'
require 'launchy'

module Server
  def self.assets ctx
    Sinatra.new do
      set :views, Proc.new { File.join(root, "../web/assets") }

      ctx.instance_exec do
        Sinatra::Application.reset!
        use Rack::Reloader, 1

        helpers Sinatra::ContentFor

        set :views, Proc.new { File.join(root, "../web/views") }
        set :public_folder, Proc.new { File.join(root, "../web/public") }
      end

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
  end

  def self.open_browser ctx, no_browser
    unless no_browser
      ctx.instance_exec {Launchy.open("http://localhost:#{settings.port}")}
    end
  end
end
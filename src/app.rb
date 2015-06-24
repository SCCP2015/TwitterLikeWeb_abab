# coding: utf-8
require 'sinatra/base'
require 'sinatra/reloader'
require 'haml'

# Sinatra Main controller
class MainApp < Sinatra::Base
  # Sinatra Auto Reload
  configure :development do
    register Sinatra::Reloader
  end
  use Rack::Session::Pool, expire_after: 2_592_000

  get '/' do
    haml :index
    # if session[:token]
    #  haml :index
    # else
    #  redirect '/Signin', 303
    # end
  end

  get '/Signin' do
    haml :signin
  end

  post '/Signin' do
    params.to_s
  end

  post '/Signup' do
    params.to_s
  end
end

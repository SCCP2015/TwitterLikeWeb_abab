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

  get '/' do
    @title = 'TwitterLike'
    haml :index
  end
end

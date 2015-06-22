# coding: utf-8
require 'sinatra/base'
require 'sinatra/reloader'

# Sinatra Main controller
class MainApp < Sinatra::Base
  # Sinatra Auto Reload
  configure :development do
    register Sinatra::Reloader
  end
  get '/' do
    'Hello World'
  end
end

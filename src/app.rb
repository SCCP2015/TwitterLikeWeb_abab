# -*- encoding: utf-8 -*-
require 'sinatra/base'
require 'sinatra/reloader'
require 'haml'
require 'net/http'
require 'uri'
require 'json'

# Sinatra Main controller
class MainApp < Sinatra::Base
  # Sinatra Auto Reload
  configure :development do
    register Sinatra::Reloader
  end
  use Rack::Session::Pool, expire_after: 2_592_000

  port = 10_000
  host = 'http://localhost:' + port.to_s + '/'

  get '/' do
    token = session[:token]
    if token
      response = post_request(
        host + 'user/auth/token', { token: token }.to_json)
      # response.body
      case response
      when Net::HTTPSuccess
        haml :index
      when Net::HTTPBadRequest
        session[:token] = nil
        redirect '/Signin', 303
      end
    else
      redirect '/Signin', 303
    end
  end

  get '/Signin' do
    haml :signin
  end

  post '/Signin' do
    name = params['name']
    password = params['pass']

    if name.empty? || password.empty?
      status 400
      'nameかパスワードが空です。'
    else
      'ほげ'
    end
  end

  post '/Signup' do
    name = params['name']
    password = params['pass']

    if name.empty? || password.empty?
      status 400
      'nameかパスワードが空です。'
    else
      response = post_request(
        host + 'users', { name: name, password: password }.to_json)
      case response
      when Net::HTTPSuccess
        session[:token] = JSON.parse(response.body)['token']
        redirect '/'
      when Net::HTTPBadRequest
        '既に登録されているユーザ名です。'
      end
    end
  end

  def get_request(path)
    uri_str = path
    uri = URI.parse(uri_str)
    req = Net::HTTP::Get.new(uri.path)
    res = Net::HTTP.start(uri.host, uri.port) { |http| http.request(req) }
    res.body
  end

  def post_request(path, body, params = nil)
    uri_str = path
    uri = URI.parse(uri_str)
    req = Net::HTTP::Post.new(uri.path,
                              'Content-Type' => 'application/json')
    req.set_form_data(params, ';') if params.nil? == false
    req.body = body
    Net::HTTP.start(uri.host, uri.port) { |http| http.request(req) }
  end
end

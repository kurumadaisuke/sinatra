require 'sinatra'
require 'sinatra/reloader'
require "sinatra/json"

set :environment, :production

json_file = 'public/memos.js'

get '/' do
  memos_json = JSON.parse(File.read(json_file))
  @titles = memos_json.values.map { |memo| memo['title'] }
  erb :index
end

get '/new' do
  erb :new
end

get '/show' do
  erb :show
end

get '/edit' do
  erb :edit
end
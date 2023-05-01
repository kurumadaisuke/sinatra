require 'sinatra'
require 'sinatra/reloader'
require "sinatra/json"

set :environment, :production

json_file = 'public/memos.js'

get '/' do
  memos_json = JSON.parse(File.read(json_file))
  @memos_title_data = memos_json.values.map { |title| title['title'] }
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
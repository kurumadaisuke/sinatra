require 'sinatra'
require 'sinatra/reloader'
require "sinatra/json"

set :environment, :production

json_file = 'public/memos.js'

get '/' do
  @memos = JSON.parse(File.read(json_file))
  erb :index
end

get '/new' do
  erb :new
end

get '/show/:id' do
  memos = JSON.parse(File.read(json_file))
  @title = memos[params[:id]]['title']
  @content = memos[params[:id]]['content']
  erb :show
end

get '/edit' do
  erb :edit
end
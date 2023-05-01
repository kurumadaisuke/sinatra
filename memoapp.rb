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

post '/new' do
  memos = JSON.parse(File.read(json_file))
  title = params[:title]
  content = params[:content]
  id = (memos.keys.max.to_i + 1).to_s
  new_memo = {"title" => title, "content" => content}
  memos[id] = new_memo

  File.open(json_file, "w") do |file|
    JSON.dump(memos,file)
  end

  redirect '/'
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
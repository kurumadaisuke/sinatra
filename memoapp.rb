# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/json'
require 'cgi'

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
  new_memo = { 'title' => title, 'content' => content }
  memos[id] = new_memo

  File.open(json_file, 'w') do |file|
    JSON.dump(memos, file)
  end

  redirect '/'
end

get '/show/:id' do
  memos = JSON.parse(File.read(json_file))
  @title = memos[params[:id]]['title']
  @content = memos[params[:id]]['content']
  @id = params[:id]
  erb :show
end

delete '/:id' do
  memos = JSON.parse(File.read(json_file))
  memos.delete(params[:id])

  File.open(json_file, 'w') do |file|
    JSON.dump(memos, file)
  end

  redirect '/'
end

get '/edit/:id' do
  memos = JSON.parse(File.read(json_file))
  @title = memos[params[:id]]['title']
  @content = memos[params[:id]]['content']
  @id = params[:id]
  erb :edit
end

patch '/edit/:id' do
  memos = JSON.parse(File.read(json_file))
  edit_title = params[:title]
  edit_content = params[:content]

  memos[params[:id]] = { 'title' => edit_title, 'content' => edit_content }

  File.open(json_file, 'w') do |file|
    JSON.dump(memos, file)
  end

  redirect "/show/#{params[:id]}"
end

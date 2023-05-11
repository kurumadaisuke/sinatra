# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/json'
require 'cgi'

set :environment, :production

json_file = 'private/memos.json'

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = JSON.parse(File.read(json_file))
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  memos = JSON.parse(File.read(json_file))
  title = params[:title]
  content = params[:content]
  id = (memos.keys.max.to_i + 1).to_s
  new_memo = { 'title' => title, 'content' => content }
  memos[id] = new_memo

  File.open(json_file, 'w') do |file|
    JSON.dump(memos, file)
  end

  redirect '/memos'
end

get '/memos/:id' do
  @memo = JSON.parse(File.read(json_file))[params[:id]]
  erb :show
end

delete '/memos/:id' do
  memos = JSON.parse(File.read(json_file))
  memos.delete(params[:id])

  File.open(json_file, 'w') do |file|
    JSON.dump(memos, file)
  end

  redirect '/memos'
end

get '/memos/:id/edit' do
  @memo = JSON.parse(File.read(json_file))[params[:id]]
  erb :edit
end

patch '/memos/:id' do
  memos = JSON.parse(File.read(json_file))
  edit_title = params[:title]
  edit_content = params[:content]

  memos[params[:id]] = { 'title' => edit_title, 'content' => edit_content }

  File.open(json_file, 'w') do |file|
    JSON.dump(memos, file)
  end

  redirect "/memos/#{params[:id]}"
end

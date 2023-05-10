# frozen_string_literal: true
# require 'debug'

require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/json'
require 'cgi'

set :environment, :production

json_file = 'private/memos.json'

# ルートからのアクセスをmemosにリダイレクト
get '/' do
  redirect '/memos'
end

# メモの一覧を表示
get '/memos' do
  @memos = JSON.parse(File.read(json_file))
  erb :index
end

# メモの新規作成画面を表示
get '/memos/new' do
  erb :new
end

# /memos/newの内容を送る
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

# 特定のメモのタイトル,内容を表示
get '/memos/:id' do
  @memos = JSON.parse(File.read(json_file))[params[:id]]
  # binding.break
  @id = params[:id]
  erb :show
end

# 特定のメモを削除
delete '/memos/:id' do
  memos = JSON.parse(File.read(json_file))
  memos.delete(params[:id])

  File.open(json_file, 'w') do |file|
    JSON.dump(memos, file)
  end

  redirect '/memos'
end

get '/memos/:id/edit' do
  @memos = JSON.parse(File.read(json_file))[params[:id]]
  @id = params[:id]
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

# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'cgi'
require 'pg'

set :environment, :production

def read_memos_db
  PG::Connection.new(dbname: 'postgres')
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  conn = read_memos_db
  @memos = conn.exec('SELECT * FROM memos')
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  conn = read_memos_db
  title = params[:title]
  content = params[:content]
  id = conn.exec("SELECT MAX(id) FROM memos")[0]["max"].to_i + 1
  conn.exec("INSERT INTO memos VALUES ('#{id}', '#{title}', '#{content}')")
  redirect '/memos'
end

get '/memos/:id' do
  conn = read_memos_db
  @memo = conn.exec("SELECT * FROM memos WHERE id = #{params[:id]}")[0]
  erb :show
end

delete '/memos/:id' do
  conn = read_memos_db
  conn.exec("DELETE FROM memos WHERE id = #{params[:id]}")
  redirect '/memos'
end

get '/memos/:id/edit' do
  conn = read_memos_db
  @memo = conn.exec("SELECT * FROM memos WHERE id = #{params[:id]}")[0]
  erb :edit
end

patch '/memos/:id' do
  conn = read_memos_db
  edit_title = params[:title]
  edit_content = params[:content]
  conn.exec("UPDATE memos SET title = '#{edit_title}', content = '#{edit_content}' WHERE id = #{params[:id]}")
  redirect "/memos/#{params[:id]}"
end

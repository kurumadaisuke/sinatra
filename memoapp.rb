# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'cgi'
require 'pg'

set :environment, :production

def read_memos_db
  PG::Connection.new(dbname: 'postgres')
end

def specific_memos
  conn = PG::Connection.new(dbname: 'postgres')
  conn.exec_params('SELECT * FROM memos WHERE id = $1', [params[:id]])[0]
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  conn = read_memos_db
  @memos = conn.exec('SELECT * FROM memos ORDER BY id DESC')
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  conn = read_memos_db
  conn.exec_params('INSERT INTO memos(title, content) VALUES ($1, $2)', [params[:title], params[:content]])
  redirect '/memos'
end

get '/memos/:id' do
  @memo = specific_memos
  erb :show
end

delete '/memos/:id' do
  conn = read_memos_db
  conn.exec_params('DELETE FROM memos WHERE id = $1', [params[:id]])
  redirect '/memos'
end

get '/memos/:id/edit' do
  @memo = specific_memos
  erb :edit
end

patch '/memos/:id' do
  conn = read_memos_db
  conn.exec_params('UPDATE memos SET title = $1, content = $2 WHERE id = $3', [params[:title], params[:content], params[:id]])
  redirect "/memos/#{params[:id]}"
end

# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'cgi'
require 'pg'
require 'connection_pool'

set :environment, :production

def memos_db_pool
  @memos_db_pool ||= ConnectionPool.new(size: 5, timeout: 3) {
    PG::Connection.new(dbname: 'postgres')
  }
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  conn = memos_db_pool.with { |connection| connection }
  @memos = conn.exec('SELECT * FROM memos')
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  conn = memos_db_pool.with { |connection| connection }
  id = conn.exec('SELECT MAX(id) FROM memos')[0]['max'].to_i + 1
  conn.exec_params('INSERT INTO memos VALUES ($1, $2, $3)', [id, params[:title], params[:content]])
  redirect '/memos'
end

get '/memos/:id' do
  conn = memos_db_pool.with { |connection| connection }
  @memo = conn.exec_params('SELECT * FROM memos WHERE id = $1', [params[:id]])[0]
  erb :show
end

delete '/memos/:id' do
  conn = memos_db_pool.with { |connection| connection }
  conn.exec_params('DELETE FROM memos WHERE id = $1', [params[:id]])
  redirect '/memos'
end

get '/memos/:id/edit' do
  conn = memos_db_pool.with { |connection| connection }
  @memo = conn.exec_params('SELECT * FROM memos WHERE id = $1', [params[:id]])[0]
  erb :edit
end

patch '/memos/:id' do
  conn = memos_db_pool.with { |connection| connection }
  conn.exec_params('UPDATE memos SET title = $1, content = $2 WHERE id = $3', [params[:title], params[:content], params[:id]])
  redirect "/memos/#{params[:id]}"
end

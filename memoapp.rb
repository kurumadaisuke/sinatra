# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'cgi'
require 'pg'

set :environment, :production

# メモに対する各機能に対するSQL文
class Memo
  def initialize
    @@conn = PG::Connection.new(dbname: 'postgres')
  end

  def self.lists
    @@conn.exec('SELECT * FROM memos ORDER BY id DESC')
  end

  def self.create(title, content)
    @@conn.exec_params('INSERT INTO memos(title, content) VALUES ($1, $2)', [title, content])
  end

  def self.specify(id)
    @@conn.exec_params('SELECT * FROM memos WHERE id = $1', [id])[0]
  end

  def self.delete(id)
    @@conn.exec_params('DELETE FROM memos WHERE id = $1', [id])
  end

  def self.edit(title, content, id)
    @@conn.exec_params('UPDATE memos SET title = $1, content = $2 WHERE id = $3', [title, content, id])
  end
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  Memo.new
  @memos = Memo.lists
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  Memo.create(params[:title], params[:content])
  redirect '/memos'
end

get '/memos/:id' do
  @memo = Memo.specify(params[:id])
  erb :show
end

delete '/memos/:id' do
  Memo.delete(params[:id])
  redirect '/memos'
end

get '/memos/:id/edit' do
  @memo = Memo.specify(params[:id])
  erb :edit
end

patch '/memos/:id' do
  Memo.edit(params[:title], params[:content], params[:id])
  redirect "/memos/#{params[:id]}"
end

require 'sinatra'
require 'sinatra/reloader'

set :environment, :production

get '/' do
  @memo1 = []
  memos = ["メモ1","メモ2","メモ3","メモ4","メモ5"]
  memos.each do |memo|
    @memo1 << memo
  end
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
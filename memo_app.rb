# frozen_string_literal: true

require 'sinatra'
require_relative './lib/memo'
require_relative './lib/memo_manager'
require_relative './lib/storage_manager'

set :environment, :development
set sessions: true, expire_after: 1200, session_secret: SecureRandom.hex(32)

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end

  def hattr(text)
    Rack::Utils.escape_path(text.to_s)
  end
end

get '/' do
  redirect '/login'
end

get '/login' do
  erb :login
end

post '/auth' do
  session[:username] = params[:username].to_sym
  session[:memo_manager] = MemoManager.new(session[:username])
  redirect '/memo'
end

get '/memos' do
  erb :index
end

get '/memos/new' do
  erb :add_memo
end

post '/memos' do
  latest_id = session[:memo_manager].add(params[:title], params[:body])
  redirect "/memo/#{latest_id}"
end

get '/memos/:memo_id' do
  @memo = session[:memo_manager].find(params[:memo_id])
  erb :memo_detail
end

get '/memos/:memo_id/edit' do
  @memo = session[:memo_manager].find(params[:memo_id])
  erb :memo_edit
end

patch '/memos/:memo_id' do
  session[:memo_manager].modify(params[:memo_id], params[:title], params[:body])
  redirect "/memo/#{params[:memo_id]}"
end

delete '/memos/:memo_id' do
  session[:memo_manager].delete(params[:memo_id])
  redirect '/memo'
end

get '/logout' do
  session.clear
  redirect '/login'
end

get '/*' do
  session[:username] && redirect('/memo')
  redirect '/'
end

before '/memos*' do
  session[:username].nil? && redirect('/login')
end

#  ログインしているユーザーからの実在しないmemo_idに対するリクエストをリダイレクト
before '/memos/:memo_id/?*' do
  params[:memo_id] == 'new' && return
  session[:memo_manager].find(params[:memo_id]).nil? && redirect('/memo')
end

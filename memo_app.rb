# frozen_string_literal: true

require 'sinatra'
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

  def current_user
    session[:username]
  end

  def memo_manager
    MemoManager.new(current_user)
  end
end

get '/' do
  redirect '/login'
end

get '/login' do
  erb :login
end

post '/auth' do
  session.clear
  session[:username] = params[:username].to_sym
  redirect '/memos'
end

get '/memos' do
  @memos = memo_manager.memos
  erb :index
end

get '/memos/new' do
  erb :add_memo
end

post '/memos' do
  latest_id = memo_manager.add(params[:title], params[:body])
  redirect "/memos/#{latest_id}"
end

get '/memos/:memo_id' do
  @memo = memo_manager.find(params[:memo_id])
  erb :memo_detail
end

get '/memos/:memo_id/edit' do
  @memo = memo_manager.find(params[:memo_id])
  erb :memo_edit
end

patch '/memos/:memo_id' do
  memo_manager.modify(params[:memo_id], params[:title], params[:body])
  redirect "/memos/#{params[:memo_id]}"
end

delete '/memos/:memo_id' do
  memo_manager.delete(params[:memo_id])
  redirect '/memos'
end

get '/logout' do
  session.clear
  redirect '/login'
end

get '/*' do
  current_user && redirect('/memos')
  redirect '/login'
end

before '/memos*' do
  current_user.nil? && redirect('/login')
end

#  ログインしているユーザーからの実在しないmemo_idに対するリクエストをリダイレクト
before '/memos/:memo_id/?*' do
  params[:memo_id] == 'new' && return
  memo_manager.find(params[:memo_id]).nil? && redirect('/memos')
end

# frozen_string_literal: true

require 'sinatra'
require_relative './lib/memo_manager'
require_relative './lib/user_manager'

set :environment, :development
set sessions: true, expire_after: 1200, session_secret: SecureRandom.hex(32)
set :root, File.dirname(__FILE__)

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end

  def hattr(text)
    Rack::Utils.escape_path(text.to_s)
  end

  def current_user
    session[:user_id]
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
  session[:user_id] = UserManager.find_user(params[:username]) || UserManager.create_user(params[:username])
  redirect '/memos'
end

get '/memos' do
  @memos = MemoManager.read(session[:user_id])
  erb :index
end

get '/memos/new' do
  erb :add_memo
end

post '/memos' do
  MemoManager.save(user_id: session[:user_id], title: params[:title], body: params[:body])
  redirect "/memos/#{MemoManager.latest_id}"
end

get '/memos/:memo_id' do
  @memo = MemoManager.find_by(session[:user_id], params[:memo_id])
  redirect('/memos') if @memo.nil?

  erb :memo_detail
end

get '/memos/:memo_id/edit' do
  @memo = MemoManager.find_by(session[:user_id], params[:memo_id])
  redirect('/memos') if @memo.nil?

  erb :memo_edit
end

patch '/memos/:memo_id' do
  redirect('/memos') if MemoManager.find_by(session[:user_id], params[:memo_id]).nil?

  MemoManager.update(id: params[:memo_id], title: params[:title], body: params[:body])
  redirect "/memos/#{params[:memo_id]}"
end

delete '/memos/:memo_id' do
  redirect('/memos') if MemoManager.find_by(session[:user_id], params[:memo_id]).nil?

  MemoManager.delete(params[:memo_id])
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

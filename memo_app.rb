# frozen_string_literal: true

require 'sinatra'
require_relative './lib/database'
require_relative './lib/db_memo_manager'
require_relative './lib/db_user_manager'

set :environment, :development
set sessions: true, expire_after: 1200, session_secret: SecureRandom.hex(32)
set :root, File.dirname(__FILE__)

db = Database.new

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
  user_manager = DbUserManager.new(db)
  session[:user_id] = user_manager.find(params[:username]) || user_manager.create(params[:username])
  redirect '/memos'
end

get '/memos' do
  memo_manager = DbMemoManager.new(db)
  @memos = memo_manager.read(session[:user_id])
  erb :index
end

get '/memos/new' do
  erb :add_memo
end

post '/memos' do
  memo_manager = DbMemoManager.new(db)
  memo_manager.create(user_id: session[:user_id], title: params[:title], body: params[:body])
  redirect "/memos/#{memo_manager.latest_id}"
end

get '/memos/:memo_id' do
  memo_manager = DbMemoManager.new(db)
  @memo = memo_manager.find(session[:user_id], params[:memo_id])
  redirect '/memos' and return if @memo.nil?

  erb :memo_detail
end

get '/memos/:memo_id/edit' do
  memo_manager = DbMemoManager.new(db)
  @memo = memo_manager.find(session[:user_id], params[:memo_id])
  redirect '/memos' and return if @memo.nil?

  erb :memo_edit
end

patch '/memos/:memo_id' do
  memo_manager = DbMemoManager.new(db)
  redirect '/memos' and return if memo_manager.find(session[:user_id], params[:memo_id]).nil?

  memo_manager.update(id: params[:memo_id], title: params[:title], body: params[:body])
  redirect "/memos/#{params[:memo_id]}"
end

delete '/memos/:memo_id' do
  memo_manager = DbMemoManager.new(db)
  redirect '/memos' and return if memo_manager.find(session[:user_id], params[:memo_id]).nil?

  memo_manager.delete(params[:memo_id])
  redirect '/memos'
end

get '/logout' do
  session.clear
  redirect '/login'
end

get '/*' do
  redirect '/memos' and return if current_user

  redirect '/login'
end

before '/memos*' do
  redirect '/login' if current_user.nil?
end

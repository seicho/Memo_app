require 'sinatra'
require 'cgi'
require_relative './lib/memo_app_method.rb'

set :environment, :development
set :sessions => true, :expire_after => 1200, :session_secret => SecureRandom.hex(32)

controler = Controler.new

get '/' do
  redirect '/login'
end

get '/login' do
  erb :login
end

post '/auth' do
  session[:username] = CGI.escapeHTML(params[:username])
  session[:memo_manager] = controler.generate_memo_manager(session[:username])
  redirect "#{session[:username]}/memo"
end

get "/:username/memo" do
  erb :index
end

get '/:username/memo/new'  do
  erb :add_memo
end

post '/:username/memo' do
  session[:memo_manager].add_memo(CGI.escapeHTML(params[:title]), CGI.escapeHTML(params[:body]))
  redirect "/#{session[:username]}/memo/#{session[:memo_manager].max_id}"
end

get '/:username/memo/:memo_id' do
  @memo = session[:memo_manager].find_memo(params[:memo_id])
  erb :memo_detail
end

get '/:username/memo/:memo_id/edit' do
  @memo = session[:memo_manager].find_memo(params[:memo_id])
  erb :memo_edit
end

patch '/:username/memo/:memo_id' do
  session[:memo_manager].modify_memo(params[:memo_id], CGI.escapeHTML(params[:title]), CGI.escapeHTML(params[:body]))
  redirect "/#{session[:username]}/memo/#{params[:memo_id]}"
end

delete '/:username/memo/:memo_id' do
  session[:memo_manager].delete_memo(params[:memo_id])
  redirect "/#{session[:username]}/memo"
end

get '/logout' do
  session.clear
  redirect '/login'
end

get '/*' do
  session[:username] && redirect("/#{session[:username]}/memo")
  redirect '/'
end
  
before '/:username/memo*' do
  session[:username].nil? && redirect('/login')
end

#  ログインしているユーザーからの実在しないmemo_idに対するリクエストをリダイレクト 
before '/:username/memo/:memo_id/?*' do
  params[:memo_id] == "new" && return
  session[:memo_manager].find_memo(params[:memo_id]).nil? && redirect("/#{session[:username]}/memo")
end

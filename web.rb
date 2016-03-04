require 'sinatra'
require 'sequel'
enable :sessions

DB = Sequel.connect(ENV['DATABASE_URL'] || "sqlite://blogs.db")

Username = "admin"
Password = "admin"


get '/' do
	@blogs = DB[:blogs].reverse_order(:id).all
	erb :index
end

get '/blog/:id' do
	@blog = DB[:blogs].where(:id => params[:id]).first
	erb :blog
end

before '/admin*' do
	if session[:is_login] != true
		redirect '/login'
	end
end 

get '/admin' do
	@blogs = DB[:blogs].reverse_order(:id).all
	erb :admin
end

get '/admin/add_blog' do
	erb :admin_add_blog
end

post '/admin/add_blog' do
	DB[:blogs].insert(:title => params[:title],
					  :summary => params[:summary],
					  :content => params[:content])
	redirect '/admin'
end

get '/admin/edit_blog/:id' do
	@blogs = DB[:blogs].where(:id => params[:id]).first
	erb :admin_edit_blog
end

post '/admin/edit_blog/:id' do
	DB[:blogs].where(:id => params[:id]).update(:title => params[:title],
					 							:summary => params[:summary],
					 							:content => params[:content])
	redirect '/admin'
end

get '/admin/delete_blog/:id' do
	DB[:blogs].where(:id => params[:id]).delete
	redirect '/admin'
end

get '/login' do
	erb :login
end

post '/login' do
	if params[:username] == Username and params[:password] == Password
		session[:is_login] = true
		redirect '/admin'
	else
		@error = true
		erb :login
	end
end

get '/logout' do
	session[:is_login] = false
	redirect '/'
end
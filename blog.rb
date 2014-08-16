require 'sinatra/base'
require "sinatra/activerecord"
require 'sinatra/flash'
require 'mysql2'
require 'rake'
require 'bcrypt'
require 'pony'
require './models'
require './functions'
require 'securerandom'

class Blog < Sinatra::Base

	helpers do
		def get_user_object(username)
			user = User.find_by(username: username)
			return user
		end
	end

	register Sinatra::ActiveRecordExtension
	include Functions
  	enable :sessions
  	register Sinatra::Flash
	
	before %r{^(?!(/|/login|/signup|/confirm/([\w]+)/([\w]+))$)} do
        redirect '/' if !check_login?
    end

    get "/confirm/:user/:token" do
		user = User.find_by(username: params[:user])
		if user.token == params[:token]
			user.update_attributes(activated: true)
			flash[:post] = "Successfully activated. Login!"
			session[:username] = user.username
			redirect '/'
		end
	end
	
	get "/" do 
  		if check_login?
  			@posts = Post.order("created_at DESC") 
  			@author = session[:username]
  			erb :post_index
  		else
  			erb :home_page, :layout => false
  		end
	end

	get '/login' do
		if check_login?
			redirect '/'
		end
		erb :login, :layout => :signlog
	end

	post "/login" do
    	log_user_in
  	end

	get "/signup" do
		if check_login?
			redirect '/'
		end
    	erb :signup, :layout => :signlog
  	end
   
	post "/signup" do
		create_user(params)
	end

	get '/posts/new' do
		@post = Post.new
		erb :post_new
	end

	

	post "/posts" do
		params[:post][:author] = session[:username]
	    @post = Post.new(params[:post])
	    if @post.save
	  		redirect "posts/#{@post.id}"
	    else
	    	erb :new
	  	end
	end

	get '/edit/:id' do
		@post = Post.find(params[:id])
		erb :post_edit, :layout => :layout
	end
  
	get "/posts/:id" do
		@comment = Comment.all.where(post_id: params[:id])
  		@post = Post.find(params[:id])
  		@author = session[:username]
  		erb :post_single
	end

	post "/posts/:id" do
	    @post = Post.find(params[:id])
	    if @post.update_attributes(params[:post])
	    	redirect "/posts/#{@post.id}"
	    else
	    	erb :edit_post
	    end
	end

	get "/posts/:id/delete" do
		Comment.delete_all(post_id: params[:id])
		Post.delete(params[:id])
		flash[:post] = "Post deleted successfully."
		redirect '/'
	end

	post "/posts/:id/comment" do
		user = User.find_by(username: session[:username])
		post = Post.find(params[:id])
		comment = Comment.new(params[:comment])
		comment.post = post
		comment.user = user
		if comment.save
			flash[:comment] = "Comment created successfully."
	  		redirect "/posts/#{params[:id]}"
	    else
	    	flash[:comment] = "Something went wrong while creating your comment."
	    	redirect "/posts/#{params[:id]}"
	  	end
	end

	get "/:post_id/:id/delete" do
		Comment.delete(params[:id])
		@post_id = params[:post_id]
		flash[:comment] = "Comment deleted successfully."
		redirect "/posts/#{@post_id}"
	end

	get "/logout" do
	    session[:username] = nil
	    flash[:home] = "Successfully logged out!"
	    redirect "/"
  	end

end
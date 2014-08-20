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

	register Sinatra::ActiveRecordExtension
	include Functions
  	enable :sessions
  	register Sinatra::Flash
	
	before %r{^(?!(/|/login|/signup|/confirm/([\w]+)|/space)$)} do
        redirect '/' if !check_login?
    end

	get "/" do 
		if check_login?
			@posts = Post.order("created_at DESC") 
			erb :post_index
		else
			erb :home_page, :layout => false
		end
	end

 	# --------------------------- START USER ----------------------------- #

    get "/confirm/:token" do
		if user = get_user_object(:activation_token, params[:token])
			flash[:login] = "You're already Activated"
			redirect '/login' if user.activated
			user.update_attributes(activated: true)
			flash[:post] = "Successfully activated. Login!"
			session[:id] = create_session_token(user)
			redirect '/'
		else
			flash[:login] = "Invalid Token"
			redirect '/login'
		end
	end

	get '/login' do
		redirect '/' if check_login?
		erb :login, :layout => :signlog
	end

	post "/login" do
    	log_user_in
  	end


	get "/logout" do
	    session[:id] = nil
	    flash[:home] = "Successfully logged out!"
	    redirect "/"
  	end

	get "/signup" do
		redirect '/' if check_login?
    	erb :signup, :layout => :signlog
  	end
   
	post "/signup" do
		create_user
	end

 	# --------------------------- END USER ----------------------------- #

 	# --------------------------- START POSTS ----------------------------- #

	get '/posts/new' do
		erb :post_new
	end

	post "/posts" do
	    post = Post.new(params[:post])
	    user = get_user_object(:session_token, session[:id])
	    post.user = user
	    if post.save
	  		redirect "post/#{post.id}"
	    else
	    	erb :new
	  	end
	end

	get '/edit/:id' do
		@post = Post.find(params[:id])
		erb :post_edit, :layout => :layout
	end
  
	get "/post/:id" do
		@comment = Comment.all.where(post_id: params[:id])
  		@post = Post.find(params[:id])
  		@author = get_current_username
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

 	# --------------------------- END POSTS ----------------------------- #

 	# --------------------------- START COMMENTS ----------------------------- #

	post "/post/:id/comment" do
		user = get_user_object(:session_token, session[:id])
		post = Post.where(id: params[:id]).first
		comment = Comment.new(params[:comment])
		comment.post = post
		comment.user = user
		if comment.save
			flash[:comment] = "Comment created successfully."
	  		redirect "/post/#{params[:id]}"
	    else
	    	flash[:comment] = "Something went wrong while creating your comment."
	    	redirect "/post/#{params[:id]}"
	  	end
	end

	get "/:post_id/:id/delete" do
		Comment.delete(params[:id])
		@post_id = params[:post_id]
		flash[:comment] = "Comment deleted successfully."
		redirect "/post/#{@post_id}"
	end

 	# --------------------------- END COMMENTS ----------------------------- #


end
require 'sinatra/base'
require "sinatra/activerecord"
require 'sinatra/partial'
require 'sinatra/flash'
require 'mysql2'
require 'rake'
require 'bcrypt'
require 'pony'
require './models'
require './functions'
require 'securerandom'

class Blog < Sinatra::Base
	use Rack::MethodOverride
	enable :sessions
	register Sinatra::ActiveRecordExtension
	register Sinatra::Partial
	register Sinatra::Flash
	include Functions

  	set :partial_template_engine, :erb

  	# This check allows visitors who haven't logged in to view only
  	# login,signup, activate and homepage. 
	before %r{^(?!(/|/login/?|/signup/?|/activate/([\w]+)/?)$)} do
        redirect '/' unless current_user
    end

    # Prevents logged in users from viewing login and signup page.
    before %r{(login/?|signup/?)$} do
    	redirect '/' if current_user
    end

    # Shows list of posts if logged in 
    # Home page if not logged in.
	get "/" do 
		if current_user
			@posts = Post.all
			erb :post_index
		else
			erb :home_page, :layout => false
		end
	end

 	# --------------------------- START USER ----------------------------- #

 	# User visits this url from email to activate account after signup
    get "/activate/:token/?" do
		if user = User.where(activation_token: params[:token]).first
			
			if user.activated
				flash[:error] = "You're already Activated"
				redirect '/login' 
			end

			user.update_attributes(activated: true)
			flash[:message] = "Successfully activated. Login!"
			session[:user_token] = create_session_token(user) #creates and uploads token to the database
			redirect '/'

		else
			flash[:error] = "Invalid Token"
			redirect '/login'
		end
	end

	# Login page
	get '/login/?' do
		erb :login, :layout => :signlog
	end

	# Does various checks to see if user can enter the blog
	post "/login" do
	    if user = User.where(username: params[:username]).first		#Checks if username exists

	      if user.activated == false	#if not activated, send them back to login
	        flash[:message] = "Check email for activation link"
	        redirect "/login" 
	      end

	      password_hash = BCrypt::Engine.hash_secret(params[:password], user.password_salt)

	      if user.password_hash == password_hash	
	        session[:user_token] = User.where(id: user.id).first.session_token
	        redirect '/'
	      else
	        flash[:error] = "Oops, looks like your credentials didn't match"
	        redirect "/login"
	      end
	    
	    else
	      flash[:error] = "Seems like you've entered the wrong details."
	      redirect "/login"
	    end
  	end

  	# Logs user out of blog
	get "/logout/?" do
	    session[:user_token] = nil
	    flash[:message] = "Successfully logged out!"
	    redirect "/"
  	end

  	# Sign up page
	get "/signup/?" do
    	erb :signup, :layout => :signlog
  	end
   
   	# Does various checks to prevent clashes in database while creating user
   	# Creates user and sends activation email if all tests are passed
	post "/signup" do

		# returns the salt and password hash to encrypt
		password_hash, password_salt = generate_password_hash_and_salt(params[:password])
	    activation_token = SecureRandom.hex

	    user = User.new(
		      username: params[:username], 
		      email: params[:email], 
		      password_salt: password_salt, 
		      password_hash: password_hash, 
		      activated: false, 
		      activation_token: activation_token
	      )

	    if user.save
	      	user.send_activation_email
	      	flash[:message] = "Success, an activation email has been sent"
	      	redirect '/signup'
	    else
	    	errors = user.errors.full_messages
	    	flash[:errors] = errors
	    	redirect '/signup'
	    end
	end

 	# --------------------------- END USER ----------------------------- #

 	# --------------------------- START POSTS ----------------------------- #

 	# Creating a new post
	get '/post/new/?' do
		erb :post_new
	end

	# Updating new post attributes to database
	post "/post/?" do
		post = current_user.posts.create(params[:post])
	    if post
	  		redirect "post/#{post.id}"
	    else
	    	erb :new
	  	end
	end

	# Viewing the contents of the post (including comments) as a blog post.
	# Also allows you to post comment.
	get "/post/:id/?" do |id|
		@post = Post.where(id: id).first
  		erb :post_single
	end

	# Editing a post
	get '/post/:id/edit/?' do |id|
		@post = current_user.posts.where(id: id).first
		if @post.user.id == current_user.id
			erb :post_edit
		else
			flash[:error] = "You do not have privileges to edit this post"
			redirect "/post/#{params[:id]}"
		end
	end

	# Altering the post attributes in the database 
	put "/post/:id" do |id|
		@post = current_user.posts.where(id: id).first
	    if @post.update_attributes(params[:post])
	    	redirect "/post/#{@post.id}"
	    else
	    	erb :post_edit
	    end
	end

	# Deleting the Post and all of its comments from the database
	delete "/post/:id" do |id|
		post = current_user.posts.where(id: id).first
		post.destroy
		flash[:message] = "Post deleted successfully."
		redirect '/'
	end

 	# --------------------------- END POSTS ----------------------------- #

 	# --------------------------- START COMMENTS ----------------------------- #

 	# Updating the comment attributes into the database of post(id) from post_single page
	post "/post/:id/comment" do |id|

		post = Post.where(id: id).first
		comment = post.comments.build(params[:comment])
		comment.user = current_user

		if comment.save
			flash[:message] = "Comment created successfully."
	  		redirect "/post/#{params[:id]}"
	    else
	    	flash[:message] = "Something went wrong while creating your comment."
	    	redirect "/post/#{params[:id]}"
	  	end
	end

	# Deleting a comment from the post from the view & database
	delete "/post/:post_id/comment/:comment_id" do |post_id, comment_id|

		post = Post.where(id: post_id).first
		comment = post.comments.where(id: comment_id).first
		if comment.user_id == current_user.id
			comment.destroy
			flash[:message] = "Comment deleted successfully."
			redirect "/post/#{post_id}"
		else
			flash[:error] = "You do not have permission to delete this comment"
			redirect "/post/#{post_id}"
		end
	end

 	# --------------------------- END COMMENTS ----------------------------- #

end
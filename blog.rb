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

# :: NOTE ::
# use only one or two flash message holders
# flash[:message] for normal messages like redirects and stuff
# and flash[:error], point being it should be generic

class Blog < Sinatra::Base

  register Sinatra::ActiveRecordExtension
  include Functions
  enable :sessions
  register Sinatra::Flash

  # ::1:: this condition seems to protect against people who are not signed in
  # from accessing routes for posts and comments, why don't we have
  # a similar condition that will not allow logged in users to access
  # /login, /signup and /activate so that you do not have to have
  # if conditions inside each of those routes
  
  # This before filter makes sure that bla bla bla
  before %r{^(?!(/|/login|/signup|/activate/([\w]+)|/space)$)} do
    redirect '/' if current_user
  end

  # This before filter makes sure that bla bla bla
  before %r{(?!(/|/login|/signup|/activate/([\w]+)|/space)$)} do
    redirect '/' if current_user
  end

  # this has been moved into the current_user method
  # please reference and call current_user for all the
  # user related requirements, its the one stop to find 
  # if a user has logged/logged out? who is the current user
  # etc.
  
  # before do
    # if check_login?
     #  @user = get_user_object(:session_token, session[:id])
    # end
  # end

  get "/" do 
    # refer 1
    if check_login?
      @posts = Post.order("created_at DESC") 
      erb :post_index
    else
      erb :home_page, :layout => false
    end
  end

  # --------------------------- START USER ----------------------------- #

  get "/activate/:token" do
    # refer 2
    if user = get_user_object(:activation_token, params[:token])

      if user.activated
        flash[:login] = "You're already Activated"
        redirect '/login'
      end

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
    redirect '/' if current_user
    erb :login, :layout => :signlog
  end

  post "/login" do
    # don't abstract such a big functionality into a method
    # please keep the control flow here, if you want to use
    # a helper method, go ahead, but all it should do it HELP!
    # ask it for something and then let it tell you, you decide what
    # to do later on.
    log_user_in
  end


  get "/logout" do
    session[:id] = nil
    flash[:home] = "Successfully logged out!"
    redirect "/"
  end

  get "/signup" do
    redirect '/' if current_user
    erb :signup, :layout => :signlog
  end

  post "/signup" do
    create_user
  end

  # --------------------------- END USER ----------------------------- #

  # --------------------------- START POSTS ----------------------------- #

  get '/post/new' do
    erb :post_new
  end

  post "/post" do
    post = Post.new(params[:post])
    post.user = current_user
    if post.save
      redirect "post/#{post.id}"
    else
      erb :new
    end
  end

  get "/post/:id" do
    # naming conventions, if something stores multiple values/records
    # then it should be plural :P
    @comment = Comment.where(post_id: params[:id])
    @post = Post.where(id: params[:id]).first
    erb :post_single
  end

  get '/post/:id/edit' do
    @post = Post.where(id: params[:id]).first
    # you are a developer, primary key ids are your single source of truth
    # developers talk id 15 or id 2341 not because its cool, they do that because
    # its the single source of truth, when vikram says user with email 'gautham@germ.io'
    # my mind has stopped thinking user, all i deal with is user id 91 from that point of time
    # because all subsequent quries i will use this id, gautham go send confirmation mail
    # sure vikram User.where(id: 91).send_confirmation_email
    # because things like user_name and email are just too uncertain
    if @post.user == current_user
      erb :post_edit
    else
      redirect "/post/#{params[:id]}"
    end
  end

  # very very very risky, learn to look at code, they say programmers can't think ui and stuff
  # all they see is code all the time and they call us geeks and make fun of us, but it is true
  # see beyond the UI when you read the code, imagine how it will run !!
  # http://stackoverflow.com/questions/5166484/sending-a-delete-request-from-sinatra
  # put "/post/:id" do
  # end
  post "/post/:id/edit" do
    post = Post.where(id: params[:id]).first
    if post.update_attributes(params[:post])
      redirect "/post/#{@post.id}"
    else
      erb :post_edit
    end
  end

  # http://stackoverflow.com/questions/5166484/sending-a-delete-request-from-sinatra
  # delete "/post/:id" do
  # end
  # http://stackoverflow.com/questions/5166484/sending-a-delete-request-from-sinatra
  # delete "/post/:id" do
  # end
  get "/post/:id/delete" do
    Comment.delete_all(post_id: params[:id])
    Post.delete(params[:id])
    flash[:post] = "Post deleted successfully."
    redirect '/'
  end

  # --------------------------- END POSTS ----------------------------- #

  # --------------------------- START COMMENTS ----------------------------- #

  post "/post/:id/comment" do
    #user = get_user_object(:session_token, session[:id])
    post = Post.where(id: params[:id]).first

    # this works but this is not the right way to go about it
    comment = Comment.new(params[:comment])
    # comment.post = post
    # comment.user = current_user

    comment = current_user.comments.build(params[:comment])
    comment.post = post
    comment.save

    if comment.save
      flash[:comment] = "Comment created successfully."
      redirect "/post/#{params[:id]}"
    else
      flash[:comment] = "Something went wrong while creating your comment."
      redirect "/post/#{params[:id]}"
    end
  end

  # delete "/post/:id/comment/:comment_id/" do
  # end
  # don't shy away in keeping full names, even if they are big :)
  get "/post/:id/comment/:commment_id/delete" do
    Comment.delete(params[:comment_id])
    @post_id = params[:id]
    flash[:comment] = "Comment deleted successfully."
    redirect "/post/#{@post_id}"
  end

  # --------------------------- END COMMENTS ----------------------------- #


end

module Functions

  def check_login?
    # is the user session id exists AND there is a corresponding current_user
    # then he is logged in
    if session[:id].nil?
      return false
    else
      return true
    end
  end

  # rename this method to current_user
  # def current_user
  #   This method will return back the current user object
  #   you do not need to have sperate is he logged in or
  #   logged out methods, all you need to do is
  #
  #   @user ||= get_user_object(:session_token, session[:id])
  #
  #   if current_user
  #     then assume he is logged in
  #   else
  #     then no one is logged in
  #   end
  # end
  
  # ::2:: please remove this method and just use 
  # regular AR finders
  # i.e User.where(...)
  def get_user_object(column, value)
    user = User.where(column => value).first
    return user
  end

  def create_session_token(user)
    session_token = SecureRandom.uuid
    user.update_attributes(session_token: session_token)
    return session_token
  end

  def get_session_token(column, value)
    user = User.where(column => value).first
    return user.session_token
  end

  def create_user
    password_salt = BCrypt::Engine.generate_salt
    password_hash = BCrypt::Engine.hash_secret(params[:password], password_salt)

    if User.where(username: params[:username]).first
      flash[:signup] = "Sorry, that username already exists"
      redirect '/signup'
    elsif User.where(email: params[:email]).first
      flash[:signup] = "Sorry, that email already exists"
      redirect '/signup'
    end

    if user = User.create(username: params[:username], email: params[:email], password_salt: password_salt, password_hash: password_hash, activated: false, activation_token: token)
      user.send_activation_email
      flash[:signup] = "Success, an activation email has been sent"
      redirect "/login"
    else
      flash[:error] = "There is some error with the database."
      redirect "/signup"
    end
  end

  def log_user_in

    if user = User.where(username: params[:username]).first

      if user.activated == false
        flash[:login] = "Check email for activation link"
        redirect "/login" 
      end

      password_hash = BCrypt::Engine.hash_secret(params[:password], user.password_salt)
      
      if user[:password_hash] == password_hash
        session[:id] = get_session_token(:username, params[:username])
        redirect '/'  
      else
        flash[:login] = "Oops, looks like your credentials didn't match"
        redirect "/login"
      end
    
    else
      flash[:login] = "Seems like you've entered the wrong details."
      redirect "/login"
    end
  end
end

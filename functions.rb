module Functions

  def check_login?
    if session[:id].nil?
      return false
    else
      return true
    end
  end

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

  def get_current_username
    username = User.where(session_token: session[:id]).first.username
    return username
  end

  def create_user
    password_salt = BCrypt::Engine.generate_salt
    password_hash = BCrypt::Engine.hash_secret(params[:password], password_salt)
    token = SecureRandom.hex

    if User.where(username: params[:username]).first
      flash[:signup] = "Sorry, that username already exists"
      redirect '/signup'
    elsif User.where(email: params[:email]).first
      flash[:signup] = "Sorry, that email already exists"
      redirect '/signup'
    end

    if user = User.create(username: params[:username], email: params[:email], password_salt: password_salt, password_hash: password_hash, activated: false, activation_token: token)
      Pony.mail(:to => "#{params[:email]}", :from => 'sidegeeks@gmail.com', :headers => { 'Content-Type' => 'text/html' }, :subject => 'Germ Blog Confirmation Mail', :body => "Click <a href='http://localhost:9292/confirm/#{token}'>here</a> to get <b>activated</b>")
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
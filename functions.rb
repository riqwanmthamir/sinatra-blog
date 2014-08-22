module Functions
  def current_user
    return false if session[:user_token].nil?
    return current_user ||= User.where(session_token: session[:user_token]).first
  end

  def create_session_token(user)
    session_token = SecureRandom.uuid #Generates univerally unique id
    user.update_attributes(session_token: session_token) #adds to database
    # return user.session_token, its much safer don't you think ?
    # you have already set the token for the user, its safest to return
    # from the user, you can garuntee that you sent the users token
    return session_token
  end

  # this is a helper function, i should be able to plug this anywhere and it
  # should work, if i just read this file, i would not have the slightest clue
  # what params[:password] is, i'm thinking what on dear planet earth is
  # params ??, just because you know where its going to get called how am
  # i supposed to know too?
  #
  # solution ? make the method take an argument password and use it
  #
  # def generate_password_hash_and_salt(password)
  # end
  #
  def generate_password_hash_and_salt
    password_salt = BCrypt::Engine.generate_salt
    password_hash = BCrypt::Engine.hash_secret(params[:password], password_salt)
    return password_hash, password_salt
  end
end

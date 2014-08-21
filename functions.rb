module Functions
  def current_user
    return false if session[:user_token].nil?
    return current_user ||= User.where(session_token: session[:user_token]).first
  end

  def create_session_token(user)
    session_token = SecureRandom.uuid #Generates univerally unique id
    user.update_attributes(session_token: session_token) #adds to database
    return session_token
  end

  def generate_password_hash_and_salt
    password_salt = BCrypt::Engine.generate_salt
    password_hash = BCrypt::Engine.hash_secret(params[:password], password_salt)
    return password_hash, password_salt
  end
end
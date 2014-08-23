class User < ActiveRecord::Base
	validates :username, :uniqueness => {:case_sensitive => false, :message => "Username already exists!"}
	validates :email, :uniqueness => {:case_sensitive => false, :message => "Email already exists!"}
	has_many :posts
	has_many :comments

	def a_method_used_for_validation_purposes
    	errors.add(:username, "already taken, try another one.")
    	errors.add(:email, "already in use")
  	end

	def send_activation_email
		
		Pony.mail(
			:to => self.email, 
			:from => 'sidegeeks@gmail.com', 
			:headers => { 'Content-Type' => 'text/html' }, 
			:subject => 'Germ Blog Confirmation Mail', 
			:body => "Click <a href='http://localhost:9292/activate/#{self.activation_token}'>here</a> to get <b>activated</b>"
			)
	end

end

class Post < ActiveRecord::Base
	default_scope { order(created_at: :desc)  }

	has_many :comments, dependent: :destroy
	belongs_to :user      
end

class Comment < ActiveRecord::Base
	belongs_to :post
	belongs_to :user
end
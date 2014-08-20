class User < ActiveRecord::Base
	has_many :posts
	has_many :comments

  def send_activation_email
    token = SecureRandom.hex

    Pony.mail(
      :to => "#{self.email}",
      :from => 'sidegeeks@gmail.com',
      :headers => { 'Content-Type' => 'text/html' },
      :subject => 'Germ Blog Confirmation Mail',
      :body => "Click <a href='http://localhost:9292/activate/#{token}'>here</a> to get <b>activated</b>"
    )
  end
end

class Post < ActiveRecord::Base
	has_many :comments
	belongs_to :user
end

class Comment < ActiveRecord::Base
	belongs_to :post
	belongs_to :user
end

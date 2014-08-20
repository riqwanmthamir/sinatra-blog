class CreateUsersPostsCommentsProperly < ActiveRecord::Migration
  def change

  	create_table 	:users do |col|
  		col.string 	:username
  		col.string 	:email
  		col.string 	:password_salt
  		col.string 	:password_hash
  		col.string	:activation_token
  		col.string	:session_token
  		col.boolean	:activated,	default: false
  	end

  	create_table :posts do |col|
  		col.belongs_to	:user
  		col.string		:title
  		col.text		:body
  		col.string		:author

  		col.timestamps
  	end  	

  	create_table :comments do |col|
	   	col.belongs_to	:user
	   	col.belongs_to	:post
	   	col.text		:body

	   	col.timestamps
	 end
  end
end
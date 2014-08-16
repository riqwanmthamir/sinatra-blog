class CreateComments < ActiveRecord::Migration
  def change
  	create_table :comments do |t|
	   	t.column	:body,			:text
	   	t.column 	:user_id,		:int
	   	t.column	:post_id,		:int
	 end
  end
end

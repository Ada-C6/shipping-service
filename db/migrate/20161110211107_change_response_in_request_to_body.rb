class ChangeResponseInRequestToBody < ActiveRecord::Migration
  def change
  	  	add_column :requests, :body, :string
  	  	remove_column :requests, :response, :string
  end
end

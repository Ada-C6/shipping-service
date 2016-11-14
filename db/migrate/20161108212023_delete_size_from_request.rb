class DeleteSizeFromRequest < ActiveRecord::Migration
  def down
    add_column :requests, :length, :integer
    add_column :requests, :width, :integer
    add_column :requests, :height, :integer
  end
end

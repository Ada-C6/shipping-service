class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.float :weight
      t.integer :origin_zip
      t.integer :destination_zip
      t.float :length
      t.float :width
      t.float :height

      t.timestamps null: false
    end
  end
end

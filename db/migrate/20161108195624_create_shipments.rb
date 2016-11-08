class CreateShipments < ActiveRecord::Migration
  def change
    create_table :shipments do |t|
      t.string :country, default: "US"
      t.string :city
      t.string :state
      t.string :zip
      t.float :weight
      t.float :length, default: 11.0
      t.float :width, default: 8.5
      t.float :height, default: 5.5
      
      t.timestamps null: false
    end
  end
end

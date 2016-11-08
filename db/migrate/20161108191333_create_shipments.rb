class CreateShipments < ActiveRecord::Migration
  def change
    create_table :shipments do |t|
      t.string :carrier
      t.float :weight
      t.float :height
      t.float :length
      t.float :width
      t.string :city
      t.string :state
      t.string :country
      t.string :zipcode
      t.string :units
      
      t.timestamps null: false
    end
  end
end

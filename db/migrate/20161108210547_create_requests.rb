class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.array :size
      t.string :seller_country
      t.string :seller_state
      t.string :seller_city
      t.string :seller_zip
      t.string :buyer_country
      t.string :buyer_state
      t.string :buyer_city
      t.string :buyer_zip

      t.timestamps null: false
    end
  end
end

class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.string :provider
      t.string :service
      t.integer :price
      t.datetime :delivery_est

      t.timestamps null: false
    end
  end
end

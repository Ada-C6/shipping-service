class CreateShippingOptions < ActiveRecord::Migration
  def change
    create_table :shipping_options do |t|
      t.string :name
      t.float  :cost

      t.timestamps null: false
    end
  end
end

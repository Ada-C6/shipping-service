class CreateShippingRates < ActiveRecord::Migration
  def change
    create_table :shipping_rates do |t|
      t.string :name
      t.integer :cost

      t.timestamps null: false
    end
  end
end

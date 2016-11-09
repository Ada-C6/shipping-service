class CreateRates < ActiveRecord::Migration
  def change
    create_table :rates do |t|
      t.belongs_to :shipment
      t.string :service_name
      t.integer :total_price

      t.timestamps null: false
    end
  end
end

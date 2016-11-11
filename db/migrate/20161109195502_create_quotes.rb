class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.belongs_to :shipment, index: true
      t.string :name
      t.integer :price
      t.timestamps null: false
    end
  end
end

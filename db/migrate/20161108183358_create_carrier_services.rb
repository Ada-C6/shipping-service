class CreateCarrierServices < ActiveRecord::Migration
  def change
    create_table :carrier_services do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end

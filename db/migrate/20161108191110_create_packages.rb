class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :state
      t.string :city
      t.string :zip
      t.integer :weight

      t.timestamps null: false
    end
  end
end

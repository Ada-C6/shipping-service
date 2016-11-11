class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.float "weight"
      t.integer "length"
      t.integer "width"
      t.integer "height"
      t.boolean "cylinder"
      t.timestamps null: false
    end
  end
end

class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.float :weight
      t.string :destination_zip

      t.timestamps null: false
    end
  end
end

class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :origin
      t.string :carrier
      t.string :service
      t.integer :cost
      t.float :weight

      t.timestamps null: false
    end
  end
end

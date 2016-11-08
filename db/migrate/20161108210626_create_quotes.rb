class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.string :carrier
      t.integer :rate
      t.belongs_to :request, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.string :provider
      t.decimal :cost

      t.timestamps null: false
    end
  end
end

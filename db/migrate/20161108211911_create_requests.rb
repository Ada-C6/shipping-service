class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.string :verb
      t.string :response

      t.timestamps null: false
    end
  end
end

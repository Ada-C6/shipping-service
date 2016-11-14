class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.string :content_type
      t.string :JSON_hash
      t.string :status_code
      t.string :request_id

      t.timestamps null: false
    end
  end
end

class AddRequestIdToResults < ActiveRecord::Migration
  def change
    add_column :results, :request_id, :integer
    add_index :results, :request_id
  end
end

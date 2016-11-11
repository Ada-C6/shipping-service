class AddColumnToShippings < ActiveRecord::Migration
  def change
    add_column :shippings, :destination_hash, :string
  end
end

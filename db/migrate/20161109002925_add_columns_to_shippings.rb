class AddColumnsToShippings < ActiveRecord::Migration
  def change
    add_column :shippings, :city, :string
    add_column :shippings, :state, :string
    add_column :shippings, :country, :string
    add_column :shippings, :zip, :string
    remove_column(:shippings, :destination_hash)
  end
end

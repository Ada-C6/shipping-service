class AddColumnWeightsToShippings < ActiveRecord::Migration
  def change
    add_column :shippings, :weights, :string
  end
end

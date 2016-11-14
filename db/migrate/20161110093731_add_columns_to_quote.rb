class AddColumnsToQuote < ActiveRecord::Migration
  def change
    add_column :quotes, :tracking_info, :string
    add_column :quotes, :delivery_estimate, :string
  end
end

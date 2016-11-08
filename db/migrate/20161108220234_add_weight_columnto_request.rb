class AddWeightColumntoRequest < ActiveRecord::Migration
  def change
    add_column :requests, :weight, :integer
  end
end

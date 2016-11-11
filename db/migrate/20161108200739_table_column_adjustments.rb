class TableColumnAdjustments < ActiveRecord::Migration
  def change
    remove_column(:packages, :cylinder)
  end
end

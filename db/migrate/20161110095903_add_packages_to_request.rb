class AddPackagesToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :packages_json, :string
  end
end

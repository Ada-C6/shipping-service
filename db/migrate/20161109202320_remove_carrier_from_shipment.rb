class RemoveCarrierFromShipment < ActiveRecord::Migration
  def change
    remove_column(:shipments, :carrier)
  end
end

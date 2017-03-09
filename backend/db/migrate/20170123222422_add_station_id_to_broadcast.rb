class AddStationIdToBroadcast < ActiveRecord::Migration[5.0]
  def change
    add_reference :broadcasts, :station, index: true
  end
end

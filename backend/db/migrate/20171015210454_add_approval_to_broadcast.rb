class AddApprovalToBroadcast < ActiveRecord::Migration[5.1]
  def change
    add_column :broadcasts, :approval, :float
  end
end

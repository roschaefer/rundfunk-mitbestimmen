class DropBalances < ActiveRecord::Migration[5.0]
  def change
    drop_view :balances, revert_to_version: 8
  end
end

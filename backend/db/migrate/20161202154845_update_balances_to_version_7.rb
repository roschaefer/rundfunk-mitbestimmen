class UpdateBalancesToVersion7 < ActiveRecord::Migration
  def change
    update_view :balances, version: 7, revert_to_version: 6
  end
end

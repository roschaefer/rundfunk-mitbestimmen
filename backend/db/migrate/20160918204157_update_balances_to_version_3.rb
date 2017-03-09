class UpdateBalancesToVersion3 < ActiveRecord::Migration
  def change
    update_view :balances, version: 3, revert_to_version: 2
  end
end

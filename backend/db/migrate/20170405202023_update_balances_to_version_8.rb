class UpdateBalancesToVersion8 < ActiveRecord::Migration
  def change
    update_view :balances, version: 8, revert_to_version: 7
  end
end

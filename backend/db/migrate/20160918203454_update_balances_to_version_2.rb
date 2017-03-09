class UpdateBalancesToVersion2 < ActiveRecord::Migration
  def change
    update_view :balances, version: 2, revert_to_version: 1
  end
end

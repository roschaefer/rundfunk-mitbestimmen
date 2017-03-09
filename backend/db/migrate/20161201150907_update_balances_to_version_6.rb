class UpdateBalancesToVersion6 < ActiveRecord::Migration
  def change
    update_view :balances, version: 6, revert_to_version: 5
  end
end

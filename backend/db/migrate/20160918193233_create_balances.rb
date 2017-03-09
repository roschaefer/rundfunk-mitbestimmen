class CreateBalances < ActiveRecord::Migration
  def change
    create_view :balances
  end
end

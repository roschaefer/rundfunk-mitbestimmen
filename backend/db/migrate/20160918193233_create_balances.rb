class CreateBalances < ActiveRecord::Migration[5.0]
  def change
    create_view :balances
  end
end

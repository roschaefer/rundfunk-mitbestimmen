class RenameSelectionToImpression < ActiveRecord::Migration[5.1]
  def change
    rename_table :selections, :impressions
  end
end

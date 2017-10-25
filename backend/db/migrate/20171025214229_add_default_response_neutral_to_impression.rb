class AddDefaultResponseNeutralToImpression < ActiveRecord::Migration[5.1]
  def change
    change_column_default :impressions, :response, 0
  end
end

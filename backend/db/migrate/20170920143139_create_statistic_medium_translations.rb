class CreateStatisticMediumTranslations < ActiveRecord::Migration[5.0]
  def change
    create_view :statistic_medium_translations
  end
end

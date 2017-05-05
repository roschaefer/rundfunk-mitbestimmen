class CreateTranslationTables < ActiveRecord::Migration[5.0]
  def change
    remove_column :topics, :name
    Topic.create_translation_table! name: :string
    remove_column :formats, :name
    Format.create_translation_table! name: :string
  end
end

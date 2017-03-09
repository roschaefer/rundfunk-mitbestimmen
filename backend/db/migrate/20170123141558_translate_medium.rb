class TranslateMedium < ActiveRecord::Migration[5.0]
  def change
    remove_column :media, :name, :string

    reversible do |dir|
      dir.up do
        Medium.create_translation_table! name: :string
      end

      dir.down do
        Medium.drop_translation_table!
      end
    end
  end
end

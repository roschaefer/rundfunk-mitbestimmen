class ChangeBroadcastMediumToReferenceMedium < ActiveRecord::Migration[5.0]
  def up
    add_reference :broadcasts, :medium, foreign_key: true, index: true

    media_ids = Broadcast.pluck(:medium).uniq
    media_ids.each do |id|
      Medium.create(id: id)
    end
    Broadcast.update_all('medium_id=medium')
    remove_column :broadcasts, :medium
  end

  def down
    add_column :broadcasts, :medium, :integer, default: 0
    remove_reference :broadcasts, :medium, foreign_key: true, index: true
  end
end

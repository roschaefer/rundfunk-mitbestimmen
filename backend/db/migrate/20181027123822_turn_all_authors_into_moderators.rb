class TurnAllAuthorsIntoModerators < ActiveRecord::Migration[5.1]
  def change
    author_ids = Broadcast.pluck(:creator_id)
    author_ids = author_ids | PaperTrail::Version.where(item_type: 'Broadcast').pluck(:whodunnit).map(&:to_i)
    author_ids = author_ids.uniq.compact
    User.where(id: author_ids).update_all(role: :moderator)
  end
end

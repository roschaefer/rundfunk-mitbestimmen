class Similarity < ApplicationRecord
  belongs_to :broadcast1, foreign_key: 'broadcast1_id', class_name: 'Broadcast'
  belongs_to :broadcast2, foreign_key: 'broadcast2_id', class_name: 'Broadcast'
  validates  :broadcast1, uniqueness: { scope: :broadcast2 }

  scope :specific_to, lambda { |user|
    return [] unless user
    where(
      'broadcast1_id in (?) or broadcast2_id in (?)',
      user.liked_broadcast_ids,
      user.liked_broadcast_ids
    )
  }

  def self.compute_all(threshold: 0, minimum_supporters: 0)
    Similarity.transaction do
      Similarity.delete_all

      supporters_per_broadcast = {}
      Broadcast.find_each do |broadcast|
        supporters = broadcast.impressions.positive.pluck(:user_id)
        supporters_per_broadcast[broadcast.id] = supporters if supporters.size >= minimum_supporters
      end

      similarities = []
      broadcast_ids = supporters_per_broadcast.keys

      time = Time.now.to_s(:db)
      broadcast_ids.each do |id1|
        broadcast_ids.each do |id2|
          if id2 > id1
            ji = jaccard_index(supporters_per_broadcast[id1], supporters_per_broadcast[id2])
            similarities << "(#{id1}, #{id2}, #{ji}, '#{time}', '#{time}')" if ji >= threshold
          end
        end
      end

      if similarities.present?
        sql = "INSERT INTO similarities (broadcast1_id, broadcast2_id, value, created_at, updated_at) VALUES #{similarities.join(', ')}"
        ActiveRecord::Base.connection.execute(sql)
      end
    end
  end

  def self.jaccard_index(supporters1, supporters2)
    union_size = (supporters1 | supporters2).size
    return 0 if union_size.zero?

    intersection_size = (supporters1 & supporters2).size
    intersection_size / union_size.to_f
  end

  def self.specific_to(user); end
end

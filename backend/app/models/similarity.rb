class Similarity < ApplicationRecord
  belongs_to :broadcast1, foreign_key: "broadcast1_id", class_name: "Broadcast"
  belongs_to :broadcast2, foreign_key: "broadcast2_id", class_name: "Broadcast"

  def self.compute_all
    Similarity.destroy_all
    Broadcast.all.each do |broadcast1|
      Broadcast.where("id > ?", broadcast1.id).each do |broadcast2|
        similarity = self.compute(broadcast1, broadcast2)
        if similarity.value > 0
          similarity.save
        end
      end
    end
  end

  def self.compute(broadcast1, broadcast2)
    similarity = Similarity.new(broadcast1: broadcast1, broadcast2: broadcast2)
    similarity.compute_jaccard
    similarity
  end

  def compute_jaccard
    supporters1 = broadcast1.impressions.where(response: 1).pluck(:user_id)
    supporters2 = broadcast2.impressions.where(response: 1).pluck(:user_id)

    union_size = (supporters1+supporters2).uniq.size
    if union_size == 0
      self.value = 0
    else
      intersection_size = (supporters1 & supporters2).uniq.size
      self.value = (intersection_size / union_size.to_f)
    end
  end
end

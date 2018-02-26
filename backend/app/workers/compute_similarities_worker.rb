class ComputeSimilaritiesWorker
  include Sidekiq::Worker
  sidekiq_options unique: :until_executed, lock_expiration: (2 * 60) # 2 minutes

  def perform
    Similarity.compute_all(threshold: 0.1, minimum_supporters: ComputeSimilaritiesWorker.minimum_supporters)
  end

  def self.minimum_supporters
    return 0 if Broadcast.count.zero?
    average_impressions_per_broadcast = Impression.count.to_f / Broadcast.count.to_f
    (average_impressions_per_broadcast * 0.05).floor
  end
end

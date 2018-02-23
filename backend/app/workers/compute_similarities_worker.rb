class ComputeSimilaritiesWorker
  include Sidekiq::Worker
  sidekiq_options unique: :until_executed, lock_expiration: (2 * 60) # 2 minutes

  def perform
    impressions_per_broadcast = Impression.group(:broadcast_id).count.values
    average = impressions_per_broadcast.inject{ |sum, el| sum + el }.to_f / impressions_per_broadcast.size
    minimum_supporters = (average * 0.05).ceil
    Similarity.compute_all(threshold: 0.1, minimum_supporters: minimum_supporters)
  end
end

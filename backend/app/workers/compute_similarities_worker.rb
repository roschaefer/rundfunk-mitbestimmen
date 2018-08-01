class ComputeSimilaritiesWorker
  include Sidekiq::Worker
  sidekiq_options lock: :until_and_while_executing, on_conflict: :reject

  def perform
    Similarity.compute_all(threshold: 0.1, minimum_supporters: ComputeSimilaritiesWorker.minimum_supporters)
  end

  def self.minimum_supporters
    return 0 if Broadcast.count.zero?
    average_impressions_per_broadcast = Impression.count.to_f / Broadcast.count.to_f
    (average_impressions_per_broadcast * 0.05).floor
  end
end

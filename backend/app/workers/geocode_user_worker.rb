class GeocodeUserWorker
  include Sidekiq::Worker

  def perform(user)
    # Do something
  end
end

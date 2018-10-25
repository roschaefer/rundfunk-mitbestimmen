require 'rails_helper'

RSpec.describe SendEmailOnBroadcastCreationJob, type: :job do
  describe ".perform_later" do
    it "adds the job to the queue :notify_broadcast_creators_on_broadcast_creation" do
      allow(UserMailer).to receive_message_chain(:notify_broadcast_creators_on_broadcast_creation, :deliver_now)
      described_class.perform_later(1)
      expect(enqueued_jobs.last[:job]).to eq described_class
    end

    it "matches with enqueued job" do
      ActiveJob::Base.queue_adapter = :test
      expect {
        SendEmailOnBroadcastCreationJob.perform_later
      }.to have_enqueued_job(SendEmailOnBroadcastCreationJob)
    end
  end
end

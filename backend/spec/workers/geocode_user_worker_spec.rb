require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe GeocodeUserWorker, type: :worker do
  around(:each) do |example|
    Sidekiq::Testing.inline! do
      example.run
    end
  end
  subject { GeocodeUserWorker.perform_async(auth0_uid) }

  context 'missing auth0_uid' do
    let(:auth0_uid) { nil }
    it { expect{ subject }.not_to raise_error }
  end
end

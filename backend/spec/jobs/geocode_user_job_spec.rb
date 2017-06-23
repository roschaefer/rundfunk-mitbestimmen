require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe GeocodeUserJob, type: :job do
  around(:each) do |example|
    Sidekiq::Testing.inline! do
      example.run
    end
  end
  subject { GeocodeUserJob.perform_later(auth0_uid) }

  context 'missing auth0_uid' do
    let(:auth0_uid) { nil }
    it { expect { subject }.not_to raise_error }
  end

  context 'no user for auth0_uid' do
    let(:auth0_uid) { 'no_user_for_that_auth0_uid' }
    it { expect { subject }.not_to raise_error }
  end
end

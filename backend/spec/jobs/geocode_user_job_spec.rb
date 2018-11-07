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

  context 'ipstack API key' do
    let(:auth0_uid) { 'whatever' }
    before { create(:user, auth0_uid: auth0_uid) } # now we would run into a request

    context 'nil' do
      before { allow(Geocoder.config).to receive(:[]).with(:ipstack).and_return(api_key: nil) }
      it { expect { subject }.not_to raise_error }
    end

    context 'blank' do
      before { allow(Geocoder.config).to receive(:[]).with(:ipstack).and_return(api_key: '') }
      it { expect { subject }.not_to raise_error }
    end
  end

  context 'no user for auth0_uid' do
    let(:auth0_uid) { 'no_user_for_that_auth0_uid' }
    it { expect { subject }.not_to raise_error }
  end
end

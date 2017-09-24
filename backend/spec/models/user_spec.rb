require 'rails_helper'
require 'support/shared_examples/database_unique_attribute'
require 'sidekiq/testing'

RSpec.describe User, type: :model do
  subject { user }
  let(:user) { create :user }
  let(:liked_broadcast) { create(:impression, response: :positive, user: user).broadcast }
  let(:disliked_broadcast) { create(:impression, response: :negative, user: user).broadcast }

  describe 'update_and_reverse_geocode' do
    subject { user.update_and_reverse_geocode(params) }
    let(:user) { create(:user) }
    describe 'latitude or longitude' do
      describe 'not changed' do
        let(:params) { { email: '1234whatever1234@example.org' } }
        specify { expect { subject }.not_to(change { user.country_code }) }
        specify { expect { subject }.not_to(change { user.state_code }) }
        specify { expect { subject }.not_to(change { user.postal_code }) }
        specify { expect { subject }.not_to(change { user.city }) }
      end

      describe 'params same as before' do
        let(:user) { create(:user, params) }
        let(:params) { { latitude: 49.0047, longitude: 8.3858 } }
        it 'does not issue a reverse geocode request' do
          expect { subject }.not_to(change { user.country_code })
        end
      end

      describe 'changed', vcr: { cassette_name: 'reverse_geocode' } do
        let(:params) { { latitude: 49.0047, longitude: 8.3858 } }
        specify { expect { subject }.to(change { user.country_code }.from(nil).to('DE')) }
        specify { expect { subject }.to(change { user.state_code }.from(nil).to('BW')) }
        specify { expect { subject }.to(change { user.postal_code }.from(nil).to('76135')) }
        specify { expect { subject }.to(change { user.city }.from(nil).to('Karlsruhe')) }
      end
    end
  end

  describe '#liked_broadcasts' do
    subject { user.liked_broadcasts }
    it { is_expected.to include(liked_broadcast) }
    it { is_expected.not_to include(disliked_broadcast) }
  end

  describe 'geocode_last_ip' do
    context 'user has no auth0_uid and no location' do
      let(:user) { build(:user, :without_geolocation, auth0_uid: nil) }
      it 'raises no error' do
        expect { user.save! }.not_to raise_error
      end
    end
  end
  describe '#assign_location_attributes', vcr: { cassette_name: 'update_location' } do
    let(:ip_address) { '141.3.135.0' }
    let(:user) { create(:user, :without_geolocation) }
    before { user }
    let(:geocoder_lookup) { Geocoder::Lookup.get(:freegeoip) }
    let(:geocoder_result) { geocoder_lookup.search(ip_address).first }

    subject do
      user.assign_location_attributes(geocoder_result)
      user.save
    end

    specify { expect { subject }.to change { User.first.latitude }.from(nil).to(49.0047) }
    specify { expect { subject }.to change { User.first.longitude }.from(nil).to(8.3858) }
    specify { expect { subject }.to change { User.first.country_code }.from(nil).to('DE') }
    specify { expect { subject }.to change { User.first.state_code }.from(nil).to('BW') }
    specify { expect { subject }.to change { User.first.postal_code }.from(nil).to('76139') }
    specify { expect { subject }.to change { User.first.city }.from(nil).to('Karlsruhe') }

    context 'no internet connection' do
      let(:geocoder_result) { nil }
      specify { expect { subject }.not_to(change { User.first.latitude }) }
    end
  end

  describe '#create' do
    let(:user) { User.create!(email: 'test@example.org') }
    it { is_expected.to be_contributor }

    context 'with a disposable email address' do
      let(:user) { create(:user, email: 'email@mvrht.com') }
      it { is_expected.to have_bad_email }
    end
  end

  describe '#email' do
    it_behaves_like 'database unique attribute', :user, email: 'email@example.org'
  end

  describe '#has_bad_email' do
    subject { user.has_bad_email? }
    it { is_expected.to be false }

    context 'explicitly set' do
      let(:user) { create(:user, has_bad_email: true) }
      it { is_expected.to be true }
    end
  end

  describe '#auth0_uid' do
    it_behaves_like 'database unique attribute', :user, auth0_uid: 'auth0|ksjdhfksdjfksjdfljsdfljsdlfjsdf'
  end

  describe '::from_token_payload' do
    subject { User.from_token_payload(payload) }

    context 'no connection to redis server' do
      subject do
        allow(Sidekiq).to receive(:redis) { raise Redis::CannotConnectError }
        Sidekiq::Testing.disable! do
          super()
        end
      end

      let(:payload) { { 'sub' => 'blablabla', 'email' => 'email@example.org' } }
      it('creates a new user') { expect { subject }.to(change { User.count }.from(0).to(1)) }
    end

    describe 'first login' do
      context 'with email in payload' do
        let(:payload) { { 'sub' => 'blablabla', 'email' => 'email@example.org' } }

        it('saves email') { expect { subject }.to(change { User.pluck(:email).first }.from(nil).to('email@example.org')) }

        it { is_expected.to be_a User }

        it('creates a new user') { expect { subject }.to(change { User.count }.from(0).to(1)) }
      end

      context 'without email in payload' do
        let(:payload) { { 'sub' => 'blablabla', 'email' => nil } }

        it('creates a new user') { expect { subject }.to(change { User.count }.from(0).to(1)) }
        it 'new user has no email' do
          subject
          expect(User.first.email).to be_nil
        end
      end

      describe 'of legacy user' do
        context 'with email in payload' do
          let(:user) { create(:user, 'email' => 'legacy@example.org', auth0_uid: nil) }
          let(:payload) { { 'sub' => 'blablabla', 'email' => 'legacy@example.org' } }
          before { user }

          it('saves the auth0_uid') { expect { subject }.to(change { User.find_by(email: 'legacy@example.org').auth0_uid }.from(nil).to('blablabla')) }
          it('returns a user') { is_expected.to be_a User }
          it('does not create new user') { expect { subject }.not_to(change { User.count }) }
        end
      end
    end

    describe 'request without sub in payload' do
      let(:payload) { {} }
      it('does not create new user') { expect { subject }.not_to(change { User.count }) }

      context 'even if email in payload' do
        let(:payload) { { 'email' => 'test@example.org' } }
        it('does not create new user') { expect { subject }.not_to(change { User.count }) }
      end
    end

    describe 'all following logins of a user' do
      let(:payload) { { 'sub' => 'blablabla', 'email' => 'existing@example.org' } }
      let(:user) { create(:user, email: 'existing@example.org', auth0_uid: 'blablabla') }
      before { user }

      it('does not create new user') { expect { subject }.not_to(change { User.count }) }
      it('returns the existing user') { is_expected.to eq user }

      context 'without email in payload' do
        let(:payload) { { 'sub' => 'blablabla', 'email' => nil } }
        it "existing user's email won't be changed" do
          subject
          expect(User.first.email).to eq 'existing@example.org'
        end
      end
    end
  end
end

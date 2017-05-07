require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe 'auth0_migration' do
    let(:user) { create(:user) }
    let(:mail) { UserMailer.auth0_migration(user) }

    it 'renders headers' do
      expect(mail.subject).to eq 'Auth0 Migration'
      expect(mail.from).to eq ['info@rundfunk-mitbestimmen.de']
      expect(mail.to).to eq [user.email]
    end

    it 'includes link to the app' do
      expect(mail.body.encoded).to match('https://rundfunk-mitbestimmen.de')
    end

    it 'sends mail' do
      expect { mail.deliver }.to(change { ActionMailer::Base.deliveries.count }.by(1))
    end

    context 'user has bad email' do
      let(:user) { create(:user, email: 'trash@trash-mail.com') }

      it 'won\'t send mail' do
        expect { mail.deliver }.not_to(change { ActionMailer::Base.deliveries.count })
      end
    end

    context 'user has no email' do
      let(:user) { create(:user, email: nil) }

      it 'won\'t send mail' do
        expect { mail.deliver }.not_to(change { ActionMailer::Base.deliveries.count })
      end
    end
  end
end

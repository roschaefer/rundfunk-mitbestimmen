require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  context 'given a moderator' do
    let(:moderator) { create(:user, role: :moderator) }
    before do
      PaperTrail.request(whodunnit: moderator.id) do
        create(:broadcast)
      end
    end

    describe '#ask_for_spam_check' do
      let(:troll) { create(:user, email: 'troll@example.org') }
      let(:spam) do
        PaperTrail.request(whodunnit: troll.id) do
          create(:broadcast, id: 4711, title: 'This broadcast is just spam')
        end
      end

      let(:mail) { UserMailer.ask_for_spam_check(spam.id, moderator.id) }

      it 'sends mail' do
        expect { mail.deliver }.to(change { ActionMailer::Base.deliveries.count }.by(1))
      end

      describe 'body' do
        it 'mentions the broadcast title' do
          expect(mail.body.encoded).to match('This broadcast is just spam')
        end

        context 'user prefers English' do
          before { moderator.update(locale: 'en') }
        end

        it 'translates' do
          expect(mail.body.encoded).to match('was recently added to the database')
        end
      end

      it 'provides a deep link to check the broadcast' do
        expect(mail.body.encoded).to match('/broadcast/4711')
      end

      describe 'subject' do
        it 'is easy to filter' do
          expect(mail.subject).to include('[Rundfunk mitbestimmen]')
        end

        context 'recipient has no preferred language' do
          it 'translates to German' do
            expect(mail.subject).to include('Neuer Sendungsbeitrag, bitte überprüfen!')
          end
        end

        context 'user prefers English' do
          before { moderator.update(locale: 'en') }

          it 'translates to English' do
            expect(mail.subject).to include('Recently added broadcast, please check!')
          end
        end
      end
    end
  end

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

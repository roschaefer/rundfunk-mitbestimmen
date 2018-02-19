import Service from '@ember/service';
import { expect } from 'chai';
import { beforeEach, describe, context, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';
import { make, manualSetup } from 'ember-data-factory-guy';

let broadcast, intl;
const sessionStub = Service.extend({
  isAuthenticated: true,
});

describe('Integration | Component | broadcast/broadcast-form', function() {
  setupComponentTest('broadcast/broadcast-form', {
    integration: true,
    setup() {
      intl = this.container.lookup('service:intl');
      intl.setLocale('en');
    }
  });
  beforeEach(function(){
    manualSetup(this.container);
    broadcast = make('broadcast', {
      title: 'I am a broadcast'
    });
  });

  context('unauthenticated', function() {
    describe('click on support button', function() {
      it('calls the login action', function(done) {
        this.set('broadcast', broadcast);
        this.set('media', []);
        this.set('stations', []);
        this.set('loginAction', function() {
          done();
        });
        this.render(hbs`{{broadcast/broadcast-form broadcast=broadcast media=media stations=stations loginAction=loginAction}}`);
        this.$('button[type="submit"]').click();
      });
    });
  });

  context('authenticated', function() {
    beforeEach(function(){
      this.register('service:session', sessionStub);
      this.inject.service('session', { as: 'sessionService' });
    });

    it('renders title and description', function() {
      this.set('broadcast', broadcast);
      this.set('media', []);
      this.set('stations', []);
      this.render(hbs`{{broadcast/broadcast-form broadcast=broadcast media=media stations=stations}}`);
      expect(this.$().text()).to.match(/Title/);
      expect(this.$().text()).to.match(/Description/);

      this.render(hbs`{{#broadcast/broadcast-form broadcast=broadcast media=media stations=stations}} template block text {{/broadcast/broadcast-form}} `);
      expect(this.$().text()).to.match(/template block text/);
    });

    describe('dropdowns', function() {
      context('given the broadcast is connected to a medium and some stations', function() {
        let stations, media;
        beforeEach(function(){
          media = [
            make('medium', {name: 'TV'}),
            make('medium', {name: 'Radio'}),
          ];
          stations = [
            make('station', {
              name: 'TVStation1',
              medium: media[0],
            }),
            make('station', {
              name: 'TVStation2',
              medium: media[0],
            }),
            make('station', {
              name: 'RadioStation1',
              medium: media[1],
            })
          ];
          broadcast.set('stations', stations.slice(0,2));
          broadcast.set('medium', media[0]);
        });

        describe('medium', function() {
          it('displays the medium of the broadcast', function() {
            this.set('broadcast', broadcast);
            this.set('media', media);
            this.set('stations', stations);
            this.render(hbs`{{broadcast/broadcast-form broadcast=broadcast media=media stations=stations}}`);
            expect(this.$('.item.active.selected').html().trim()).to.eq('TV');
          });

          it('change medium clears stations', function() {
            this.set('broadcast', broadcast);
            this.set('media', media);
            this.set('stations', stations);
            this.render(hbs`{{broadcast/broadcast-form broadcast=broadcast media=media stations=stations}}`);
            expect(this.$('.ui.label')).to.have.length(2);
            expect(this.$('.media.dropdown')).to.have.length(1);
            this.$('.media.dropdown').click();
            expect(this.$('.media.dropdown div.item[data-value="1"]')).to.have.length(1);
            this.$('.media.dropdown div.item[data-value="1"]').click();
            expect(this.$('.ui.label')).to.have.length(0);
          });
        });

        describe('station', function() {
          it('displays all stations of the broadcast', function() {
            this.set('broadcast', broadcast);
            this.set('media', media);
            this.set('stations', stations);
            this.render(hbs`{{broadcast/broadcast-form broadcast=broadcast media=media stations=stations}}`);
            expect(this.$('.ui.label')).to.have.length(2);
            expect(this.$('.ui.label').text()).to.match(/TVStation1/);
            expect(this.$('.ui.label').text()).to.match(/TVStation2/);
          });
        });
      });
    });
  });

});

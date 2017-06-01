import Ember from 'ember';
import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';

const sessionStub = Ember.Service.extend({
  isAuthenticated: false
});

describe('Integration | Component | decision card deck next step', function() {
  setupComponentTest('decision-card-deck-next-step', {
    integration: true
  });

  it('renders', function() {
    this.render(hbs`{{decision-card-deck-next-step}}`);
    expect(this.$()).to.have.length(1);
  });

  it('renders translations', function() {
    this.inject.service('intl');
    this.container.lookup('service:intl').setLocale('en');
    this.register('service:session', sessionStub);
    this.inject.service('session', { as: 'sessionService' });

    this.render(hbs`{{decision-card-deck-next-step positiveReviews=1}}`);
    expect(this.$().text()).to.match(/More suggestions/);

    this.render(hbs`
    {{#decision-card-deck-next-step}}
      template block text
    {{/decision-card-deck-next-step}}
  `);
    expect(this.$().text()).to.match(/template block text/);
  });

  it('encourages the user to load more suggestions', function() {
    this.inject.service('intl');
    this.container.lookup('service:intl').setLocale('en');
    this.register('service:session', sessionStub);
    this.inject.service('session', { as: 'sessionService' });

    this.render(hbs`{{decision-card-deck-next-step positiveReviews=0}}`);
    let primary = this.$('.primary.button').text();
    expect(primary).to.match(/More suggestions/);
  });

  it('when selected 3 positives, user is can distribute budget', function() {
    this.inject.service('intl');
    this.container.lookup('service:intl').setLocale('en');
    this.register('service:session', sessionStub);
    this.inject.service('session', { as: 'sessionService' });

    this.render(hbs`{{decision-card-deck-next-step positiveReviews=3}}`);
    this.set('sessionService.isAuthenticated', true);
    let primary = this.$('.primary.button').text();
    expect(primary).to.match(/Distribute budget/);
  });
});




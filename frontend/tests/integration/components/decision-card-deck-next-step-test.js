import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import instanceInitializer from '../../../instance-initializers/ember-intl';
import Ember from 'ember';

const sessionStub = Ember.Service.extend({
  isAuthenticated: false
});

moduleForComponent('decision-card-deck-next-step', 'Integration | Component | decision card deck next step', {
  integration: true,
  setup() {
    // manually invoke the ember-intl initializer
    instanceInitializer.initialize(this);
    let intl = this.container.lookup('service:intl');
    intl.setLocale('en');
  },
  beforeEach: function () {
    this.register('service:session', sessionStub);
    this.inject.service('session', { as: 'sessionService' });
  }
});

test('it renders', function(assert) {

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{decision-card-deck-next-step positiveReviews=1}}`);

  let text = this.$().text();
  assert.ok(text.match(/More suggestions/));

  // Template block usage:
  this.render(hbs`
    {{#decision-card-deck-next-step}}
      template block text
    {{/decision-card-deck-next-step}}
  `);

  text = this.$().text();
  assert.ok(text.match(/template block text/));
});

test('encourages the user to load more suggestions', function(assert) {
  this.render(hbs`{{decision-card-deck-next-step positiveReviews=0}}`);
  let primary = this.$('.primary.button').text();
  assert.ok(primary.match(/More suggestions/));
});

test('when selected 3 positives, user is can distribute budget', function(assert) {
  this.render(hbs`{{decision-card-deck-next-step positiveReviews=3}}`);
  this.set('sessionService.isAuthenticated', true);
  let primary = this.$('.primary.button').text();
  assert.ok(primary.match(/Distribute budget/));
});


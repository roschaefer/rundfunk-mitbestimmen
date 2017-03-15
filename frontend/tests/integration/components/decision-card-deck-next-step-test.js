import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import instanceInitializer from '../../../instance-initializers/ember-intl';

moduleForComponent('decision-card-deck-next-step', 'Integration | Component | decision card deck next step', {
  integration: true,
  setup() {
    // manually invoke the ember-intl initializer
    instanceInitializer.initialize(this);
    let intl = this.container.lookup('service:intl');
    intl.setLocale('en');
  },
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

test('before authentication, user is asked to sign up', function(assert) {
  this.render(hbs`{{decision-card-deck-next-step positiveReviews=3}}`);
  let primary = this.$('.primary.button').text();
  assert.ok(primary.match(/Sign up/));
});

test('after authentication, user is can distribute budget', function(assert) {
  this.render(hbs`{{decision-card-deck-next-step positiveReviews=3}}`);
  this.set('session.isAuthenticated', true);
  let primary = this.$('.primary.button').text();
  assert.ok(primary.match(/Distribute budget/));
});


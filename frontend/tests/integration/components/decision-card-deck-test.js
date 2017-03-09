import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import { makeList, manualSetup } from 'ember-data-factory-guy';
import instanceInitializer from '../../../instance-initializers/ember-intl';

moduleForComponent('decision-card-deck', 'Integration | Component | decision card deck', {
  integration: true,
  setup() {
    // manually invoke the ember-intl initializer
    instanceInitializer.initialize(this);
    let intl = this.container.lookup('service:intl');
    intl.setLocale('en');
  },
  beforeEach() {
    manualSetup(this.container);
  }
});

test('initially 1 visible broadcast', function(assert) {
  this.set('someBroadcasts', makeList('broadcast', 3));
  this.render(hbs`{{decision-card-deck broadcasts=someBroadcasts}}`);
  let length = this.$('.decision-card').length;
  assert.equal(length, 1);
});

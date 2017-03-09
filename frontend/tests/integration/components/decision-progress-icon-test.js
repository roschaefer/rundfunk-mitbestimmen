import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import { make, manualSetup } from 'ember-data-factory-guy';

moduleForComponent('decision-progress-icon', 'Integration | Component | decision progress icon', {
  integration: true,
  beforeEach() {
    manualSetup(this.container);
  }
});

test('it renders', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.set('aBroadcast', make('broadcast'));
  this.render(hbs`{{decision-progress-icon broadcast=aBroadcast}}`);

  assert.equal(this.$().text().trim(), '');

  // Template block usage:
  this.render(hbs`
    {{#decision-progress-icon broadcast=aBroadcast}}
      template block text
    {{/decision-progress-icon}}
  `);

  assert.equal(this.$().text().trim(), 'template block text');
});

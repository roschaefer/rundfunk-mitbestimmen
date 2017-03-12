import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import { make, manualSetup } from 'ember-data-factory-guy';
import instanceInitializer from '../../../instance-initializers/ember-intl';

moduleForComponent('decision-card', 'Integration | Component | decision card', {
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

test('shows display button if it has a decide action', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.set('aBroadcast', make('broadcast'));
  this.render(hbs`{{decision-card decide=true broadcast=aBroadcast}}`);

  let text = this.$().text();
  assert.ok(text.match(/Support/));
  assert.ok(text.match(/Next/));
});

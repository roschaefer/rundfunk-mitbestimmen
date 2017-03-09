import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import instanceInitializer from '../../../instance-initializers/ember-intl';

moduleForComponent('invoice-footer', 'Integration | Component | invoice footer', {
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

  this.set('remaining', 5.0);
  this.set('total', 10.0);
  this.render(hbs`{{invoice-footer total=total remaining=remaining}}`);

  let text = this.$().text();
  assert.ok(text.match(/€5.00/));
  assert.ok(text.match(/€10.00/));
});

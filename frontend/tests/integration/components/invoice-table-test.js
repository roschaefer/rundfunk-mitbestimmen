import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import instanceInitializer from '../../../instance-initializers/ember-intl';

moduleForComponent('invoice-table', 'Integration | Component | invoice table', {
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
  let invoiceStub = {
    total: function() {
      return 11.0;
    },
    leftOver: function() {
      return 6.5;
    }
  };

  this.set('invoice', invoiceStub);
  this.render(hbs`{{invoice-table invoice=invoice}}`);
  let text = this.$().text();
  assert.ok(text.match(/Title/));
  assert.ok(text.match(/Amount/));
  assert.ok(text.match(/Budget/));
});

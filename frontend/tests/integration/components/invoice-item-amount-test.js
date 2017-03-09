import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import instanceInitializer from '../../../instance-initializers/ember-intl';

moduleForComponent('invoice-item-amount', 'Integration | Component | invoice item amount', {
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

  this.set('amount', 5.0);
  this.render(hbs`{{invoice-item-amount amount=amount}}`);

  let text = this.$().text();
  assert.ok(text.match(/€5.00/));


});


test('sanitizes input for changeAmountAction', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.set('checkSanitized', (amount) => {
    assert.equal(amount, 7.0);
  });
  this.set('amount', 5.0);
  this.render(hbs`{{invoice-item-amount amount=amount changeAmountAction=(action checkSanitized)}}`);

  this.$('.ember-inline-edit').click();
  this.$('.ember-inline-edit-input').val('€7.0');
  this.$('.ember-inline-edit-input').trigger('input');
  this.$('.ember-inline-edit-save').click();
});


test('commas and dots are treated the same', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.set('checkSanitized', (amount) => {
    assert.equal(amount, 7.0);
  });
  this.set('amount', 5.0);
  this.render(hbs`{{invoice-item-amount amount=amount changeAmountAction=(action checkSanitized)}}`);

  this.$('.ember-inline-edit').click();
  this.$('.ember-inline-edit-input').val('€7,0');
  this.$('.ember-inline-edit-input').trigger('input');
  this.$('.ember-inline-edit-save').click();
});

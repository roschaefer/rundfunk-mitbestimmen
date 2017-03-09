import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import Ember from 'ember';
import instanceInitializer from '../../../instance-initializers/ember-intl';

moduleForComponent('invoice-item', 'Integration | Component | invoice item', {
  integration: true,
  setup() {
    // manually invoke the ember-intl initializer
    instanceInitializer.initialize(this);
    let intl = this.container.lookup('service:intl');
    intl.setLocale('en');
  }
});

test('it renders', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  let selection = Ember.Object.create({
    amount: 9.99,
    broadcast: {
      title: "Whatever",
    }
  });
  this.set('selection', selection);
  this.on('removeItem', function(selection) { return selection; });

  this.render(hbs`{{invoice-item selection=selection removeAction=(action 'removeItem')}}`);

  let text = this.$().text();
  assert.ok(text.match(/Whatever/));

});

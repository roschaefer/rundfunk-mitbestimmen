import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import instanceInitializer from '../../../instance-initializers/ember-intl';

moduleForComponent('broadcast-form', 'Integration | Component | broadcast form', {
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

  this.render(hbs`{{broadcast-form}}`);

  let text = this.$().text();
  assert.ok(text.match(/Title/));
  assert.ok(text.match(/Description/));

  // Template block usage:
  this.render(hbs`
    {{#broadcast-form}}
      template block text
    {{/broadcast-form}}
  `);

  text = this.$().text();


  assert.ok(text.match(/template block text/));
});

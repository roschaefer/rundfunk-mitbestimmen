import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import instanceInitializer from '../../../instance-initializers/ember-intl';

moduleForComponent('signup-modal', 'Integration | Component | signup modal', {
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

  this.render(hbs`{{signup-modal}}`);

  assert.ok(this.$().text().match(/Sign up/));

  // Template block usage:
  this.render(hbs`
    {{#signup-modal}}
      template block text
    {{/signup-modal}}
  `);

  assert.ok(this.$().text().match(/template block text/));
});

import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import instanceInitializer from '../../../instance-initializers/ember-intl';

moduleForComponent('fa-question', 'Integration | Component | fa question', {
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

  this.render(hbs`{{fa-question key='finances'}}`);

  let text = this.$().text().trim();
  assert.ok(text.match(/Who is financing this\?/));
  assert.ok(text.match(/We ourselves/));

  // Template block usage:
  this.render(hbs`
    {{#fa-question key='finances'}}
      template block text
    {{/fa-question}}
  `);

  text = this.$().text().trim();
  assert.ok(text.match(/template block text/));
});

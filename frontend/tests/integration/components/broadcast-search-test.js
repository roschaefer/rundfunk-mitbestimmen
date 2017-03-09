import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import instanceInitializer from '../../../instance-initializers/ember-intl';
import { makeList, manualSetup } from 'ember-data-factory-guy';

moduleForComponent('broadcast-search', 'Integration | Component | broadcast search', {
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

test('it renders', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.set('totalCount', 10);
  this.set('filterParams', {
    get(){
      return 'primary';
    }
  });
  this.set('stations', makeList('station', 3));
  this.set('media', makeList('medium', 2));
  this.render(hbs`{{broadcast-search totalCount=totalCount stations=stations media=media filterParams=filterParams}}`);

  let text = this.$().text();
  assert.ok(text.match(/10\s+results/));

  // Template block usage:
  this.render(hbs`
    {{#broadcast-search stations=stations media=media filterParams=filterParams}}
      template block text
    {{/broadcast-search}}
  `);

  text = this.$().text();
  assert.ok(this.$().text().match(/template block text/));
});

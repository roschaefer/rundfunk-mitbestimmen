import { expect } from 'chai';
import { beforeEach, context, describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';

describe('Integration | Component | geo/info box', function() {
  setupComponentTest('geo/info-box', {
    integration: true
  });

  let properties;
  context('given a property set of a federal state', function() {
    beforeEach(function(){
      properties = {
        state: 'Brandenburg',
        count: 24,
        totalGermanUsers: 200,
        totalUsers: 220,
      };
    });

    it('shows number of users in state and the percentage compared to Germany', function() {
      this.set('properties', properties);
      this.render(hbs`{{geo/info-box properties=properties}}`);
      let text = this.$().text();
      expect(text).to.match(/Brandenburg/);
      expect(text).to.match(/24/);
      expect(text).to.match(/12.00%/);
    });
  });

  context('given no federal state, just the numbers of all Germany', function() {
    beforeEach(function(){
      properties = {
        totalGermanUsers: 200,
        totalUsers: 220,
      };
    });

    it('shows number of users in state and the percentage compared to Germany', function() {
      this.set('properties', properties);
      this.render(hbs`{{geo/info-box properties=properties}}`);
      let text = this.$().text();
      expect(text).to.match(/Germany/);
      expect(text).to.match(/200/);
      expect(text).to.match(/90.91%/);
    });
  });
});

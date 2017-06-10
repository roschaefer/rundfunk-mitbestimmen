import { expect } from 'chai';
import { beforeEach, describe, context, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';
import { makeList, manualSetup } from 'ember-data-factory-guy';

describe('Integration | Component | find broadcasts/empty list', function() {
  setupComponentTest('find-broadcasts/empty-list', {
    integration: true
  });
  beforeEach(function(){
    manualSetup(this.container);
  });

  let broadcasts;
  context('broadcasts are empty', function() {
    beforeEach(function(){
      broadcasts = makeList('broadcast', 0);
    });

    it('displays broadcast form', function() {
      this.set('broadcasts', broadcasts);
      this.render(hbs`{{find-broadcasts/empty-list broadcasts=broadcasts}}`);
      expect(this.$('.broadcast-form')).to.have.length(1);
    });

    it('asks the user to create missing broadcast', function() {
      this.set('broadcasts', broadcasts);
      this.render(hbs`{{find-broadcasts/empty-list broadcasts=broadcasts}}`);
      expect(this.$('.help-message.create-missing-broadcast')).to.have.length(1);
    });

    it('does not ask the user the change the search params, as pagination could give more results', function() {
      this.set('broadcasts', broadcasts);
      this.render(hbs`{{find-broadcasts/empty-list broadcasts=broadcasts}}`);
      expect(this.$('.help-message.change-search-params')).to.have.length(0);
    });

    context('and search yields no results', function() {
      beforeEach(function(){
        broadcasts.totalPages = 0;
      });

      it('asks the user the change the search params', function() {
        this.set('broadcasts', broadcasts);
        this.render(hbs`{{find-broadcasts/empty-list broadcasts=broadcasts}}`);
        expect(this.$('.help-message.change-search-params')).to.have.length(1);
      });
    });
  });
});

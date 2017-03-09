import ENV from 'frontend/config/environment';
import JSONAPIAdapter from 'ember-data/adapters/json-api';
import DataAdapterMixin from 'ember-simple-auth/mixins/data-adapter-mixin';
import Ember from 'ember';

export default JSONAPIAdapter.extend(DataAdapterMixin, {
  authorizer: 'simple-auth-authorizer:jwt',
  host: ENV.APP.BACKEND_URL,
  pathForType: function(type) {
    return Ember.String.pluralize(Ember.String.underscore(type));
  },
  intl: Ember.inject.service(),
  headers: Ember.computed('intl.locale', function() {
    return {
      'locale': this.get('intl').get('locale'),
    };
  })

});

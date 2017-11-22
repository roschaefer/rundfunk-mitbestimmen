import ENV from 'frontend/config/environment';
import JSONAPIAdapter from 'ember-data/adapters/json-api';
import Ember from 'ember';
import DataAdapterMixin from 'ember-simple-auth/mixins/data-adapter-mixin';

export default JSONAPIAdapter.extend(DataAdapterMixin, {
  authorizer: 'authorizer:jwt',
  host: ENV.APP.BACKEND_URL,
  pathForType: function(type) {
    if (type === 'impression'){
      // see https://github.com/roschaefer/rundfunk-mitbestimmen/issues/419
      return 'votes';
    } else {
      return Ember.String.pluralize(Ember.String.underscore(type));
    }
  },
  intl: Ember.inject.service(),
  headers: Ember.computed('intl.locale', function() {
    return {
      'locale': this.get('intl').get('locale'),
    };
  })
});

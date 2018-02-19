import ENV from 'frontend/config/environment';
import JSONAPIAdapter from 'ember-data/adapters/json-api';
import { underscore } from '@ember/string';
import { pluralize } from 'ember-inflector';
import { inject as service } from '@ember/service';
import { computed } from '@ember/object';
import DataAdapterMixin from 'ember-simple-auth/mixins/data-adapter-mixin';

export default JSONAPIAdapter.extend(DataAdapterMixin, {
  authorizer: 'authorizer:jwt',
  host: ENV.APP.BACKEND_URL,
  pathForType: function(type) {
    if (type === 'impression'){
      // see https://github.com/roschaefer/rundfunk-mitbestimmen/issues/419
      return 'votes';
    } else {
      return pluralize(underscore(type));
    }
  },
  intl: service(),
  headers: computed('intl.locale', function() {
    return {
      'locale': this.get('intl').get('locale'),
    };
  })
});

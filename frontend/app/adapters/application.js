import ENV from 'frontend/config/environment';
import JSONAPIAdapter from 'ember-data/adapters/json-api';
import { underscore } from '@ember/string';
import { pluralize } from 'ember-inflector';
import { inject as service } from '@ember/service';
import { computed } from '@ember/object';
import DataAdapterMixin from 'ember-simple-auth/mixins/data-adapter-mixin';
import { isPresent } from '@ember/utils';


export default JSONAPIAdapter.extend(DataAdapterMixin, {
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
  }),
  authorize(xhr){
    const { idToken } = this.get('session.data.authenticated');
    if (isPresent(idToken)) {
      xhr.setRequestHeader('Authorization', `Bearer ${idToken}`);
    }
  }
});

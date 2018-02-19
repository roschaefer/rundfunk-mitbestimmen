import DS from 'ember-data';
import { computed } from '@ember/object';

export default DS.Model.extend({
  title: DS.attr('string'),
  description: DS.attr('string'),
  imageUrl: DS.attr('string'),
  broadcastUrl: DS.attr('string'),
  createdAt: DS.attr('date'),
  updatedAt: DS.attr('date'),
  medium: DS.belongsTo('medium'),
  stations: DS.hasMany('station'),
  impressions: DS.hasMany('impression'),

  response: computed('impressions.firstObject.response', function() {
    return this.get('impressions.firstObject.response');
  }),

  setDefaultResponse(response){
    return this.get('impressions.firstObject') || this.respond(response);
  },
  respond(response){
    let firstImpression = this.get('impressions.firstObject');
    if (['positive', 'neutral'].includes(response)){
      if (firstImpression){
        firstImpression.set('response', response);
        if (response === 'neutral'){
          firstImpression.set('amount', null);
          firstImpression.set('fixed', false);
        }
      } else {
        firstImpression = this.get('store').createRecord('impression', {
          broadcast: this,
          response: response,
        });
        this.get('impressions').addObject(firstImpression);
      }
    }
    return firstImpression;
  },

  saveAndSetSuccess(){
    this.save().then(() => {
      this.set('success', true);
    }).catch(() => {
      this.set('success', false);
    });
  }
});

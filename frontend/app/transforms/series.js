import DS from 'ember-data';

export default DS.Transform.extend({
  deserialize(serialized) {
    serialized.map((series) => {
      if (series['data']){
        series['data'] = series['data'].map((d) => {
          return parseFloat(d);
        });
      }
      return series;
    });
    return serialized;
  },

  serialize(deserialized) {
    return deserialized;
  }
});

import DS from 'ember-data';

export default DS.Transform.extend({
  deserialize(serialized) {
    serialized.map((series) => {
      series['data'] = series['data'].map((d) => {
        return parseFloat(d);
      });
      if (series['y-axis']){
        series['yAxis'] = series['y-axis'];
      }
      if (series['tooltip']){
        series['tooltip'] = {
          'valueSuffix': series['tooltip']['value-suffix'],
          'valueDecimals': series['tooltip']['value-decimals']
        };
      }
      return series;
    });
    return serialized;
  },

  serialize(deserialized) {
    return deserialized;
  }
});

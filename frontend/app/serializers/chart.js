import DS from 'ember-data';
import { ActiveModelSerializer } from 'active-model-adapter';

export default ActiveModelSerializer.extend({

  normalize(modelClass, resourceHash, prop) {
    resourceHash['series'].forEach( (serie) => {
      serie.data.forEach( (d) => {
        d.x = d3.time.format('%Y-%m-%d').parse(d.x);
      });
    });

    resourceHash['timeline'].forEach( (t) => {
      t.x = d3.time.format('%Y-%m-%d').parse(t.x);
    });

    return this._super(modelClass, resourceHash, prop);
  },

});

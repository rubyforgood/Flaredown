import DS from 'ember-data';
import { ActiveModelSerializer } from 'active-model-adapter';

export default ActiveModelSerializer.extend({

  normalize(modelClass, resourceHash, prop) {
    return this._super(modelClass, resourceHash, prop);
  },

});

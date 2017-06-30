import Ember from 'ember';
import ApplicationAdapter from 'flaredown/adapters/application';

const {
  getProperties,
  $,
} = Ember;

export default ApplicationAdapter.extend({
  urlForDeleteRecord(id, modelName, snapshot) {
    if (typeof FastBoot === 'undefined') {
      const params = $.param({ reaction: getProperties(snapshot.serialize(), 'value', 'reactable_id', 'reactable_type') });

      return `${this._buildURL(modelName, id)}?${params}`;
    }
  },
});

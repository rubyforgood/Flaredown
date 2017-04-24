import Ember from 'ember';
import ApplicationAdapter from 'flaredown/adapters/application';

const {
  getProperties,
  $: {
    param,
  },
} = Ember;

export default ApplicationAdapter.extend({
  urlForDeleteRecord(id, modelName, snapshot) {
    const params = param({ reaction: getProperties(snapshot.serialize(), 'value', 'reactable_id', 'reactable_type') });

    return `${this._buildURL(modelName, id)}?${params}`;
  },
});

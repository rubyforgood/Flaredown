import DS from 'ember-data';
import { ActiveModelSerializer } from 'active-model-adapter';

export default ActiveModelSerializer.extend(DS.EmbeddedRecordsMixin, {

  attrs: {
    conditions: { embedded: 'always' },
    symptoms: { embedded: 'always' },
    treatments: { embedded: 'always' }
  },

  serialize(snapshot, options) {
    var json = this._super(...arguments);
    json.conditions_attributes = json.conditions;
    delete json.conditions;
    json.symptoms_attributes = json.symptoms;
    delete json.symptoms;
    json.treatments_attributes = json.treatments;
    delete json.treatments;

    return json;
  },

});

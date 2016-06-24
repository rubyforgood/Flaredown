import DS from 'ember-data';
import { ActiveModelSerializer } from 'active-model-adapter';

export default ActiveModelSerializer.extend(DS.EmbeddedRecordsMixin, {

  attrs: {
    conditions: { embedded: 'always' },
    symptoms: { embedded: 'always' },
    treatments: { embedded: 'always' }
  },

  serialize() {
    var json = this._super(...arguments);

    json.conditions_attributes = json.conditions;
    delete json.conditions;

    json.symptoms_attributes = json.symptoms;
    delete json.symptoms;

    json.treatments_attributes = json.treatments;
    json.treatments_attributes.forEach(function(item) {
      item.value = item.dose.name;
      delete item.dose;
    });
    delete json.treatments;

    return json;
  }

});

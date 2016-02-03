import DS from 'ember-data';
import { ActiveModelSerializer } from 'active-model-adapter';

export default ActiveModelSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    conditions: { embedded: 'always' },
    symptoms: { embedded: 'always' },
    treatments: { embedded: 'always' }
  }
});

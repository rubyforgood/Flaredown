import DS from 'ember-data';
import { ActiveModelSerializer } from 'active-model-adapter';

const {
  EmbeddedRecordsMixin,
} = DS;

export default ActiveModelSerializer.extend(EmbeddedRecordsMixin, {
  attrs: {
    reactions: { embedded: 'always' },
  },
});

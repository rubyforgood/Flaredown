import DS from 'ember-data';
import { ActiveModelSerializer } from 'active-model-adapter';

const {
  EmbeddedRecordsMixin,
} = DS;

export default ActiveModelSerializer.extend(EmbeddedRecordsMixin, {
  normalizeResponse(store, primaryModelClass, payload, id, requestType) {
    payload.posts.forEach((post) => {
      post.id = post._id
    })

    return this._super(...arguments);
  },
});

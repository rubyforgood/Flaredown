import Ember from 'ember';
import AuthenticatedRouteMixin from 'flaredown/mixins/authenticated-route-mixin';

const {
  get,
  Route,
  getProperties,
} = Ember;

export default Route.extend(AuthenticatedRouteMixin, {
  model() {
    return get(this, 'store')
      .query('postable', { page: 1 })
      .then(postables => {
        const fakePostable = get(postables, 'firstObject');

        const { posts, comments } = getProperties(fakePostable, 'posts', 'comments');

        return posts.toArray().concat(comments.toArray());
      });
  },
});

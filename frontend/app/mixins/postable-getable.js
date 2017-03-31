import Ember from 'ember';

const {
  get,
  Mixin,
  getProperties,
} = Ember;

export default Mixin.create({
  getPostables(page) {
    return get(this, 'store').query('postable', { page }).then(postables => {
      const fakePostable = get(postables, 'firstObject');
      const { posts, comments } = getProperties(fakePostable, 'posts', 'comments');

      return posts.toArray().concat(comments.toArray());
    });
  },
});

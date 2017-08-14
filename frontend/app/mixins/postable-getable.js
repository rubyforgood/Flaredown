import Ember from 'ember';

const {
  get,
  inject: {
    service,
  },
  RSVP,
  Mixin,
  getProperties,
} = Ember;

export default Mixin.create({
  fastboot: service(),

  getPostables(page, crossedTheLine) {
    const store = get(this, 'store');

    if (get(this, 'fastboot.isFastBoot') || crossedTheLine) {
      console.log('fastboot: ', store.query('postable', { page }));
      return store.query('postable', { page }).then((postables) => {
        const fakePostable = get(postables, 'firstObject');
        const { posts, comments } = getProperties(fakePostable, 'posts', 'comments');

        return posts.toArray().concat(comments.toArray());
      });
    } else {
      return RSVP.resolve(store.peekAll('postable')).then((postables) => {
        const fakePostable = get(postables, 'firstObject');
        const { posts, comments } = getProperties(fakePostable, 'posts', 'comments');

        return posts.toArray().concat(comments.toArray());
      });
    }
  },
});

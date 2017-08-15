import Ember from 'ember';

const {
  get,
  set,
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

    if (get(this, 'fastboot.isFastBoot') || crossedTheLine || get(this, 'fastboot.hasPeeked')) {
      return store.query('postable', { page }).then((postables) => {
        const fakePostable = get(postables, 'firstObject');
        const { posts, comments } = getProperties(fakePostable, 'posts', 'comments');

        return posts.toArray().concat(comments.toArray());
      });
    } else {
      set(this, 'fastboot.hasPeeked', true);

      return RSVP.resolve(store.peekAll('postable')).then((postables) => {
        const fakePostable = get(postables, 'firstObject');
          const { posts, comments } = getProperties(fakePostable, 'posts', 'comments');

          return posts.toArray().concat(comments.toArray());
      });
    }
  },
});

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

    const makeRequest = get(this, 'fastboot.isFastBoot') || crossedTheLine || get(this, 'fastboot.hasPeeked');
    const promise = makeRequest ? store.query('postable', { page }) : RSVP.resolve(store.peekAll('postable'));

    return promise.then((postables) => {
      const fakePostable = get(postables, 'firstObject');
      const { posts, comments } = getProperties(fakePostable, 'posts', 'comments');

      return posts.toArray().concat(comments.toArray());
    });
  },
});

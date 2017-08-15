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

    const makeRequest = get(this, 'fastboot.isFastBoot') || crossedTheLine;
    const promise = makeRequest ? store.query('postable', { page }) : RSVP.resolve(this.peekData(store, page));

    return promise.then((postables) => {
      const fakePostable = get(postables, 'firstObject');
      const { posts, comments } = getProperties(fakePostable, 'posts', 'comments');

      return posts.toArray().concat(comments.toArray());
    });
  },

  peekData(store, page) {
    const postables = store.peekAll('postable');

    return postables.toArray().length > 0 ? postables : store.query('postable', { page });
  }
});

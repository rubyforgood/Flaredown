import Ember from 'ember';
import PostableGetable from 'flaredown/mixins/postable-getable';

const {
  set,
  Controller,
  getProperties,
  setProperties,
  computed: {
    sort,
    alias,
  },
} = Ember;

export default Controller.extend(PostableGetable, {
  page: 1,
  postablesSort: ['createdAt:desc'],

  postables: sort('model', 'postablesSort'),
  screenName: alias('session.currentUser.profile.screenName'),

  actions: {
    crossedTheLine(above) {
      if (above) {
        let { page, model } = getProperties(this, 'page', 'model');

        set(this, 'loadingPostables', true);

        page += 1;

        this.getPostables(page).then(postables => {
          model.pushObjects(postables);

          setProperties(this, { page, loadingPostables: false });
        });
      }
    },
  },
});

import Ember from 'ember';
import BackNavigateable from 'flaredown/mixins/back-navigateable';

const {
  get,
  set,
  isEmpty,
  computed,
  Controller,
  getProperties,
  computed: {
    alias,
  },
} = Ember;

export default Controller.extend(BackNavigateable, {
  post: alias('model'),

  disabled: computed('newComment.body', function() {
    return isEmpty(get(this, 'newComment.body'));
  }),

  actions: {
    submitComment() {
      const { post, store, newComment } = getProperties(this, 'post', 'store', 'newComment');

      set(newComment, 'post', post);
      get(post, 'comments').pushObject(newComment);

      newComment
        .save()
        .then(() => {
          set(this, 'newComment', store.createRecord('comment'));
        });
    },
  },
});

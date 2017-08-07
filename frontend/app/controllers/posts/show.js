import Ember from 'ember';
import BackNavigateable from 'flaredown/mixins/back-navigateable';
import SearchableDropdown from 'flaredown/mixins/searchable-dropdown';
import NavbarSearchable from 'flaredown/mixins/navbar-searchable';

const {
  get,
  set,
  isEmpty,
  computed,
  Controller,
  getProperties,
  inject: {
    service,
  },
  computed: {
    alias,
  },
} = Ember;

export default Controller.extend(BackNavigateable, SearchableDropdown, NavbarSearchable, {
  ajax: service(),
  notifications: service(),
  session: service(),

  queryParams: ['anchor'],

  post: alias('model'),
  anchor: null,

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

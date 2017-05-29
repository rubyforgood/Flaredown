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
  run: {
    schedule,
  },
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

  post: alias('model'),

  disabled: computed('newComment.body', function() {
    return isEmpty(get(this, 'newComment.body'));
  }),

  init() {
    this._super(...arguments);

    schedule('afterRender', this, this.didEnterViewport);
  },

  didEnterViewport() {
    const { ajax, post } = getProperties(this, 'ajax', 'post');

    if (get(post, 'notifications.reaction')) {
      const id = get(post, 'id');

      ajax
        .del(`notifications/post/${id}`)
        .then(() => set(post, 'notifications', {}))
        .then(() => get(this, 'notifications').unloadNotification({ notificateableId: id }));
    }
  },

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

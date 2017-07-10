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
  session: service(),

  queryParams: ['anchor'],

  post: alias('model'),
  anchor: null,

  disabled: computed('newComment.body', function() {
    return isEmpty(get(this, 'newComment.body'));
  }),

  init() {
    this._super(...arguments);

    schedule('afterRender', this, this.didEnterViewport);
  },

  didEnterViewport() {
    const { ajax, post } = getProperties(this, 'ajax', 'post');

    if (post && get(post, 'notifications.reaction')) {
      const id = get(post, 'id');
      const store = get(this, 'store');

      ajax
        .put(`notifications/post/${id}`)
        .then(({notifications}) => {

          notifications.forEach((n) => {
            const model = store.peekRecord('notification', n.id);

            if(model){
              set(model, 'unread', false);
            }
          });
          set(post, 'notifications', {});
        });
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

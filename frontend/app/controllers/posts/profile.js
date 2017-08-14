import Ember from 'ember';
import PostableGetable from 'flaredown/mixins/postable-getable';
import BackNavigateable from 'flaredown/mixins/back-navigateable';
import SearchableDropdown from 'flaredown/mixins/searchable-dropdown';
import NavbarSearchable from 'flaredown/mixins/navbar-searchable';

const {
  get,
  set,
  Controller,
  getProperties,
  setProperties,
  computed: {
    sort,
    alias,
  },
  inject: {
    service,
  },
} = Ember;

export default Controller.extend(PostableGetable, BackNavigateable, SearchableDropdown, NavbarSearchable, {
  page: 1,
  postablesSort: ['createdAt:desc'],

  notifications: service(),

  postables: sort('model', 'postablesSort'),
  screenName: alias('session.currentUser.profile.screenName'),

  actions: {
    crossedTheLine(above) {
      if (above) {
        let { page, model } = getProperties(this, 'page', 'model');

        set(this, 'loadingPostables', true);

        page += 1;

        this.getPostables(page, get(this, 'loadingPostables')).then((postables) => {
          model.pushObjects(postables);

          setProperties(this, { page, loadingPostables: false });
        });
      }
    },
  },
});

import Ember from 'ember';
import SearchableDropdown from 'flaredown/mixins/searchable-dropdown';

const {
  get,
  $,
  computed,
  inject: {
    service,
  },
  computed: {
    alias,
  },
  Component
} = Ember;

export default Component.extend(SearchableDropdown, {
  tagName: 'header',
  classNames: ['flex-container', 'nav'],
  classNameBindings: ['isAuthenticatedUser::unauthenticatedNav'],

  showSearch: false,
  optionObjects: null,
  searchObjects: null,

  notifications: service(),
  routeHistory:  service(),
  _routing:      service('-routing'),
  postId: alias('notifications.first.postId'),

  click() {
    if(!get(this, 'isAuthenticatedUser')) {
      get(this, '_routing').transitionTo('signup');
    }
  },

  didInsertElement(){
    const state = {
      direction: 0,
      pos: $(window).scrollTop(),
    };

    $(window).on('scroll', () => {
      let currentDirection = $(window).scrollTop();
      if(currentDirection > state.pos) {
        $('.nav').addClass('hideNavBar');
      } else {
        $('.nav').removeClass('hideNavBar');
      }
      state.pos = currentDirection;
    });
  },

  didDestroyElement() {
    $(window).off('scroll');
  },


  navigateBackHistory: computed('routeHistory.history', function() {
    return get(this, 'routeHistory.history.length') >= 2;
  }),

  actions: {
    toggleSearchBar() {
      this.toggleProperty('showSearch');
    },

    searchObjects(query) {
      this.sendAction('onSearch', query);
    },

    goToSelectedTopic(selected) {
      if(selected) {
        this.sendAction('onGo', selected);
      }
    },

    navigateBack() {
      const routing = get(this, '_routing');
      const previous = get(this, 'routeHistory').popEntry();

      if (previous) {
        routing.transitionTo(...previous);
      }
    },
  }
});

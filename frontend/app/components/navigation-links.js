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

export default Component.extend({SearchableDropdown,
  classNames: ['flex-container', 'nav'],
  tagName: 'header',
  showSearch: false,

  optionObjects: null,
  searchObjects: null,
  go: null,

  notifications: service('notifications'),
  routeHistory:  service('routeHistory'),
  postId: alias('notifications.first.postId'),
  _routing:      service('-routing'),

  didInsertElement(){
    const state = {
      direction: 0,
      pos: $(window).scrollTop()
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
    }
  }
});

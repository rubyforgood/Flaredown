import Ember from 'ember';
import SearchableDropdown from 'flaredown/mixins/searchable-dropdown';

const {
  get,
  $,
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

  selectedObject: null,
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

  actions: {
    showSearchBar() {
      this.toggleProperty('showSearch');
    },

    searchObjects(query) {
      this.sendAction('onSearch', query);
    },

    go() {
      let selectedObject = get(this, 'selectedObject');
      if(selectedObject) {
        this.sendAction('onGo', selectedObject);
      }
    },

    navigateBack() {
      const routing = get(this, '_routing');
      const previous = get(this, 'routeHistory').popEntry();

      if (previous) {
        routing.transitionTo(...previous);
      } else {
        routing.transitionTo('posts');
      }
    }
  }
});

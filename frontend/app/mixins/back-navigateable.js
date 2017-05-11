import Ember from 'ember';

const {
  get,
  Mixin,
  inject: {
    service,
  },
} = Ember;

export default Mixin.create({
  routeHistory: service(),

  actions: {
    navigateBack() {
      const previous = get(this, 'routeHistory').popEntry();

      if (previous) {
        this.transitionToRoute(...previous);
      } else {
        this.transitionToRoute('posts');
      }
    },
  },
});

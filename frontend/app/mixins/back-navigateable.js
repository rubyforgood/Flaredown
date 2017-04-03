import Ember from 'ember';

const {
  Mixin,
} = Ember;

export default Mixin.create({
  actions: {
    navigateBack() {
      window.history.back();
    },
  },
});

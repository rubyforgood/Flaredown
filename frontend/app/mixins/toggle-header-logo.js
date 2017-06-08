import Ember from 'ember';

const {
  set,
  inject: {
    service,
  },
  Mixin,
} = Ember;

export default Mixin.create({
  logoVisiability: service(),

  activate() {
    set(this, 'logoVisiability.showHeaderLogo', false);
  },

  deactivate() {
    set(this, 'logoVisiability.showHeaderLogo', true);
  },
});

import Ember from 'ember';

const {
  Component,
  computed: {
    alias,
  },
  inject: {
    service,
  },
} = Ember;

export default Component.extend({
  logoVisiability: service(),
  showHeaderLogo: alias('logoVisiability.showHeaderLogo'),
});

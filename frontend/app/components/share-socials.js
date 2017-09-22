import Ember from 'ember';

const {
  computed,
  Component,
} = Ember;

export default Component.extend({
  classNames: ['shareSocials'],
  divideTitles: false,

  baseUrl: computed(function() {
    let location = window.location;

    return location.protocol + "//" + location.host;
  }),
});

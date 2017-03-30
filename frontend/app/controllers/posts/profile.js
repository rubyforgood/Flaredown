import Ember from 'ember';

const {
  Controller,
  computed: {
    alias,
  },
} = Ember;

export default Controller.extend({
  screenName: alias('session.currentUser.profile.screenName'),
});

import Ember from 'ember';

const {
  Controller,
  computed: {
    sort,
    alias,
  },
} = Ember;

export default Controller.extend({
  postablesSort: ['createdAt:desc'],

  postables: sort('model', 'postablesSort'),
  screenName: alias('session.currentUser.profile.screenName'),
});

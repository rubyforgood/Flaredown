import Ember from 'ember';

const {
  Component,
  inject: {
    service,
  },
  computed: {
    alias,
  },
} = Ember;

export default Component.extend({
  tagName: '',

  notifications: service(),

  postId: alias('notifications.first.postId'),
});

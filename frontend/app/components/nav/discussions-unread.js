import Ember from 'ember';

const {
  get,
  computed,
  Component,
  getProperties,
  inject: {
    service,
  },
} = Ember;

export default Component.extend({
  tagName: '',

  notifications: service(),

  postId: computed('notifications.first', function() {
    const {
      notificateableId,
      notificateableType,
      notificateableParentId,
    } = getProperties(
      get(this, 'notifications.first') || {},
      'notificateableId',
      'notificateableType',
      'notificateableParentId'
    );

    return notificateableType === 'comment' ? notificateableParentId : notificateableId;
  }),
});

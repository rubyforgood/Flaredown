import Ember from 'ember';

let { Component, computed , get, set, $: { ajax } } = Ember;

export default Component.extend({
  tagName: '',

  authHeader: computed('session.data.authenticated.token', 'session.currentUser.email', function() {
    return `Token token="${get(this, 'session.data.authenticated.token')}", ` +
      `email="${get(this, 'session.currentUser.email')}"`;
  }),

  actions: {
    scheduleDataExport() {
      ajax({
        url: '/api/data_export_schedules',
        method: 'POST',
        dataType: 'json',

        headers: {
          Authorization: get(this, 'authHeader'),
        },

        statusCode: {
          201: () => set(this, 'exportIsScheduled', true),
        },
      });
    },
  },
});

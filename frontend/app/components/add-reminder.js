import Ember from 'ember';
import { translationMacro as t } from "ember-i18n";

/* global moment */

const {
  set,
  computed,
  computed: {
    alias,
  },
  inject: {
    service,
  },
  Component,
} = Ember;

export default Component.extend({
  i18n: service(),

  profile: alias('model'),

  classNames: ['checkinReminder'],

  checkinReminderEnabled: alias('profile.checkinReminder'),

  reminderOff: "Don't remind me",
  reminderOn:  "Send me an email reminder",
  title: null,

  timezones: computed(function() {
    return typeof moment !== 'undefined' && moment.tz && moment.tz.names();
  }),

  actions: {
    changeReminder(boolParam) {
      set(this, 'profile.checkinReminder', boolParam);
    },

    timeChanged(param) {
      set(this, 'profile.checkinReminderAt', param);
    }
  },
});

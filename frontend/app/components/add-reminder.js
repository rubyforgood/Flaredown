import Ember from 'ember';
import { translationMacro as t } from "ember-i18n";

const {
  set,
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

  reminderOff: t("step.onboarding.reminder.reminderOff"),
  reminderOn:  t("step.onboarding.reminder.reminderOn"),
});

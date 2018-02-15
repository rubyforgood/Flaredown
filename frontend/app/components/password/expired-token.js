import Ember from 'ember';
import { translationMacro as t } from "ember-i18n";

const {
  inject: { service },
  Component,
} = Ember;

export default Component.extend({
  i18n: service(),

  tagName: 'div',
  classNames: ['expired-box'],

  textBeforeLink: t("password.update.textBeforeLink"),
  textAfterLink: t("password.update.textAfterLink"),
});

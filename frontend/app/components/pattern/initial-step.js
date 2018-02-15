import Ember from 'ember';
import { translationMacro as t } from "ember-i18n";

const {
  inject: { service },
  Component
} = Ember;

export default Component.extend({
  i18n: service(),

  classNames: ['flaredown-transparent-box'],
  buttonLabel: t("history.step.initial.buttonText"),
});

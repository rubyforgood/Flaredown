import Ember from 'ember';
import { translationMacro as t } from "ember-i18n";

const {
  get,
  set,
  inject: { service },
  Component
} = Ember;

export default Component.extend({
  classNames: ['reset-password-form'],

  i18n: service(),

  successfulResetMsg: t("password.reset.successMsg"),
  errorResetMsg: t("password.reset.errorMsg"),

  setupModel: Ember.on('init', function(){
    this.set('model', this.store.createRecord('password'));
  }),

  onWillDestroyElement: Ember.on('willDestroyElement', function(){
    this.discardChanges();
  }),

  discardChanges() {
    var model = this.get('model');
    if( model.get('isNew') ) {
      var statePath = model.get('stateManager.currentPath');
      if (!Ember.isEqual(statePath,'created.inFlight')) {
        model.transitionTo('created.uncommitted');
      }
      model.deleteRecord();
    }
  },

  actions: {
    resetPassword() {
      get(this, 'model').save().then( () => {
        set(this, 'model', this.store.createRecord('password'));
        set(this, 'resetPassMessage', get(this, 'successfulResetMsg'));
      }, (error) => {
        set(this, 'resetPassMessage', get(this, 'errorResetMsg'));
      });
    }
  }
});

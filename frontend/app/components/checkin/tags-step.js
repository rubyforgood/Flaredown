import Ember from 'ember';

export default Ember.Component.extend({

  model: Ember.computed.alias('parentView.model'),
  checkin: Ember.computed.alias('model.checkin'),

  saveCheckin: function() {
    this.get('checkin').save().then(() => {
      Ember.Logger.debug('Checkin successfully saved');
    });
  },

  actions: {
    completeStep() {
      this.saveCheckin();
      this.get('onStepCompleted')();
    },

    goBack() {
      this.saveCheckin();
      this.get('onGoBack')();
    }
  }

});

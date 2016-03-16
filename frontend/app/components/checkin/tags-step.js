import Ember from 'ember';
import CheckinAutosave from 'flaredown/mixins/checkin-autosave';

export default Ember.Component.extend(CheckinAutosave, {

  model: Ember.computed.alias('parentView.model'),
  checkin: Ember.computed.alias('model.checkin'),

  actions: {
    addTag(tag) {
      this.get('checkin').addTag(tag);
    },
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

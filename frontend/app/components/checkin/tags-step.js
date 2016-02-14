import Ember from 'ember';
import RunEvery from 'flaredown/mixins/run-every';

export default Ember.Component.extend(RunEvery, {

  model: Ember.computed.alias('parentView.model'),
  checkin: Ember.computed.alias('model.checkin'),

  autosaveCheckin: Ember.on('init', function() {
    this.runEvery(2, () => {
      this.saveCheckin();
    });
  }),

  isSaving: false,
  saveCheckin: function() {
    var checkin = this.get('checkin');
    if (!this.get('isSaving') && Ember.isPresent(checkin) && checkin.hasChanged()) {
      this.set('isSaving', true);
      checkin.save().then(savedCheckin => {
        checkin.set('tagsChanged', false);
        this.set('isSaving', false);
        Ember.Logger.debug('Checkin successfully saved');
      });
    } else {
      Ember.Logger.debug("Checkin didn't change, no need to save");
    }
  },

  actions: {
    completeStep() {
      this.get('onStepCompleted')();
    },
    goBack() {
      this.get('onGoBack')();
    }
  }

});

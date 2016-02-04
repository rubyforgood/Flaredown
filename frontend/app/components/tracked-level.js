import Ember from 'ember';

export default Ember.Component.extend({

  classNames: ['tracked-level'],

  values: [0,1,2,3,4],

  setCurrentValue: Ember.on('init', function() {
    var valueKey = this.get('valueKey');
    Ember.RSVP.resolve(this.get('model')).then(model => {
      this.set('currentValue', model.get(valueKey));
    });
  }),

  noValueSet: Ember.computed.none('currentValue'),

  label: Ember.computed.alias('model.label'),

  actions: {

    pipClick(pipValue) {
      Ember.Logger.debug('pipClick');
      Ember.Logger.debug(pipValue);
      this.get('model').set(this.get('valueKey'), pipValue);
      this.set('currentValue', pipValue);
    },

    xClick() {
      Ember.Logger.debug('xClick');
      var model = this.get('model');
      this.get('onRemove')(model);
    }
  }

});

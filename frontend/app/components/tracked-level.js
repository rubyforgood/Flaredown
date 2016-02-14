import Ember from 'ember';

export default Ember.Component.extend({

  classNames: ['tracked-level'],

  values: [0,1,2,3,4],

  setCurrentValue: Ember.on('init', function() {
    var valueKey = this.get('valueKey');
    Ember.RSVP.resolve(this.get('model')).then(model => {
      var value = model.get(valueKey);
      if (Ember.isPresent(value)) {
        this.set('currentValue', value);
      }
    });
  }),

  noValueSet: Ember.computed.none('currentValue'),

  label: Ember.computed.alias('model.label'),

  actions: {

    pipClick(pipValue) {
      this.get('model').set(this.get('valueKey'), pipValue);
      this.set('currentValue', pipValue);
    },

    xClick() {
      var model = this.get('model');
      this.get('onRemove')(model);
    }
  }

});

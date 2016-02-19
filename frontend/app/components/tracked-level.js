import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['tracked-level'],

  label: Ember.computed.alias('model.label'),

  pips: [
    { value: 0, tooltip: 'very well' },
    { value: 1, tooltip: 'Slightly below par' },
    { value: 2, tooltip: 'Poor' },
    { value: 3, tooltip: 'Very poor' },
    { value: 4, tooltip: 'Terrible' }
  ],

  onDidInsertElement: Ember.on('didInsertElement', function() {
    Ember.run.scheduleOnce('afterRender', this, () => {
      Ember.RSVP.resolve(this.get('model')).then(model => {
        var value = model.get(this.get('valueKey'));
        if (Ember.isPresent(value)) {
          this.set('selectedValue', value);
        }
      });

    });
  }),

  actions: {

    setSelectedValue(pipValue) {
      this.set('selectedValue', pipValue);
      // TODO update into parent
      this.get('model').set(this.get('valueKey'), pipValue);
    },

    setCurrentValue(pipValue) {
      this.set('currentValue', pipValue);
    },

    unsetCurrentValue() {
      this.set('currentValue', null);
    },

    xClick() {
      var model = this.get('model');
      this.get('onRemove')(model);
    }
  }

});

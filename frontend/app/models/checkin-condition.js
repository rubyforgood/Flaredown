import DS from 'ember-data';
import Ember from 'ember';
import CheckinTrackable from 'flaredown/models/checkin-trackable';

export default CheckinTrackable.extend({
  value: DS.attr('number'),

  condition: DS.belongsTo('condition'),

  setPropsFromCondition: Ember.on('init', Ember.observer('condition', function() {
    this.get('condition').then(condition => {
      if (Ember.isPresent(condition)) {
        this.set('label', condition.get('name'));
        if (Ember.isBlank(this.get('colorId'))) {
          this.set('colorId', condition.get('colorId'));
        }
      }
    });
  }))

});

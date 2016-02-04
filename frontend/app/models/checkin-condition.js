import DS from 'ember-data';
import Ember from 'ember';

export default DS.Model.extend({
  value: DS.attr('number'),
  condition: DS.belongsTo('condition'),

  setPropsFromCondition: Ember.on('init', function() {
    this.get('condition').then(condition => {
      this.set('label', condition.get('name'));
      this.set('bgClass', condition.get('bgClass'));
    });
  })
});

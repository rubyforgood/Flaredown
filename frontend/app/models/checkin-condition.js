import DS from 'ember-data';
import Ember from 'ember';
import ColorClassesMixin from 'flaredown/mixins/color-classes';

export default DS.Model.extend(ColorClassesMixin, {
  value: DS.attr('number'),
  condition: DS.belongsTo('condition'),
  colorId: DS.attr('string'),

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

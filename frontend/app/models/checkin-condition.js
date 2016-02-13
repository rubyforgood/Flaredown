import DS from 'ember-data';
import Ember from 'ember';
import Colorable from 'flaredown/mixins/colorable';
import NestedDestroyable from 'flaredown/mixins/nested-destroyable';

export default DS.Model.extend(Colorable, NestedDestroyable, {
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

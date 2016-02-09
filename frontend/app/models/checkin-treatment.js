import DS from 'ember-data';
import Ember from 'ember';
import ColorableMixin from 'flaredown/mixins/colorable';
import NestedDestroyableMixin from 'flaredown/mixins/nested-destroyable';

export default DS.Model.extend(ColorableMixin, NestedDestroyableMixin, {
  value: DS.attr('string'),
  isTaken: DS.attr('boolean'),

  treatment: DS.belongsTo('treatment'),

  setPropsFromTreatment: Ember.on('init', Ember.observer('treatment', function() {
    this.get('treatment').then(treatment => {
      if (Ember.isPresent(treatment)) {
        this.set('label', treatment.get('name'));
        if (Ember.isBlank(this.get('colorId'))) {
          this.set('colorId', treatment.get('colorId'));
        }
      }
    });
  }))

});

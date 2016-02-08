import DS from 'ember-data';
import ColorableMixin from 'flaredown/mixins/colorable';
import NestedDestroyableMixin from 'flaredown/mixins/nested-destroyable';

export default DS.Model.extend(ColorableMixin, NestedDestroyableMixin, {
  value: DS.attr('number'),

  symptom: DS.belongsTo('symptom'),

  setPropsFromSymptom: Ember.on('init', Ember.observer('symptom', function() {
    this.get('symptom').then(symptom => {
      if (Ember.isPresent(symptom)) {
        this.set('label', symptom.get('name'));
        if (Ember.isBlank(this.get('colorId'))) {
          this.set('colorId', symptom.get('colorId'));
        }
      }
    });
  }))

});

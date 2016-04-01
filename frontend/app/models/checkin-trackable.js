import Ember from 'ember';
import DS from 'ember-data';
import Colorable from 'flaredown/mixins/colorable';
import NestedDestroyable from 'flaredown/mixins/nested-destroyable';

export default DS.Model.extend(Colorable, NestedDestroyable, {

  init() {
    this._super(...arguments);
    /* We need to make sure that the hasDirtyAttributes property has been consumed at least once
       in order to activate the observer. See:
       https://guides.emberjs.com/v2.4.0/object-model/observers/#toc_unconsumed-computed-properties-do-not-trigger-observers
    */
    this.get('hasDirtyAttributes');
  },

  syncCheckinDirty: Ember.observer('hasDirtyAttributes', function() {
    this.setCheckinDirty();
  }),

  checkin: DS.belongsTo('checkin'),

  setCheckinDirty() {
    if (this.get('hasDirtyAttributes')) {
      let checkin = this.get('checkin.content');
      if (Ember.isPresent(checkin)) {
        checkin.set('hasDirtyAttributes', true);
      }
    }
  }

});

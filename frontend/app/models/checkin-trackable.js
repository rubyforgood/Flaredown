import Ember from 'ember';
import DS from 'ember-data';
import Colorable from 'flaredown/mixins/colorable';
import NestedDestroyable from 'flaredown/mixins/nested-destroyable';

export default DS.Model.extend(Colorable, NestedDestroyable, {

  checkin: DS.belongsTo('checkin'),

  setCheckinDirty: Ember.on('init', Ember.observer('hasDirtyAttributes', function() {
    if (this.get('hasDirtyAttributes')) {
      if (!this.get('checkin.hasDirtyAttributes')) {
        this.get('checkin').set('hasDirtyAttributes', true);
      }
    }
  }))

});

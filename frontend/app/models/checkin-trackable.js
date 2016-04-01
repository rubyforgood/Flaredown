import Ember from 'ember';
import DS from 'ember-data';
import Colorable from 'flaredown/mixins/colorable';
import NestedDestroyable from 'flaredown/mixins/nested-destroyable';

export default DS.Model.extend(Colorable, NestedDestroyable, {

  checkin: DS.belongsTo('checkin'),

  syncCheckinDirty: Ember.on('init', Ember.observer('hasDirtyAttributes', function() {
    this.setCheckinDirty();
  })),

  setCheckinDirty() {
    Ember.RSVP.resolve(this.get('checkin')).then(checkin => {
      if (Ember.isPresent(checkin) && this.get('hasDirtyAttributes')) {
        if (!checkin.get('hasDirtyAttributes')) {
          checkin.set('hasDirtyAttributes', true);
        }
      }
    });
  }

});

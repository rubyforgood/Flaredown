import DS from 'ember-data';

export default DS.Model.extend({
  startAt: DS.attr(),
  endAt: DS.attr(),

  //Associations
  checkins: DS.hasMany('checkin', { async: false } ),
  trackables: DS.hasMany('trackable', { async: false, polymorphic: true, inverse: null } )

});

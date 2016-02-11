import DS from 'ember-data';

export default DS.Model.extend({
  searchables: DS.hasMany('searchable', { async: false, polymorphic: true, inverse: null } ),
});

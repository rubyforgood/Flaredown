import DS from 'ember-data';

export default DS.Model.extend({
  startAt: DS.attr(),
  endAt: DS.attr(),
  series: DS.attr()
});

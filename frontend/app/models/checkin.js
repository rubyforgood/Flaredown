import DS from 'ember-data';

export default DS.Model.extend({
  date: DS.attr('date'),
  conditions: DS.attr(),
  symptoms: DS.attr(),
  treatments: DS.attr(),

  formattedDate: Ember.computed('date', function() {
    return moment(this.get('date')).format("YYYY-MM-DD")
  }),
});

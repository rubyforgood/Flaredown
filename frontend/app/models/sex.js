import DS from 'ember-data';

export default DS.Model.extend({

  //Attributes
  name: DS.attr('string'),
  rank: DS.attr('number')

});

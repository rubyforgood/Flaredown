import DS from 'ember-data';
import Searchable from 'flaredown/mixins/searchable';

export default DS.Model.extend(Searchable, {

  //Attributes
  name: DS.attr('string')

});

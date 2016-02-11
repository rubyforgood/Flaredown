import DS from 'ember-data';
import Searchable from 'flaredown/mixins/searchable';

export default DS.Model.extend(Searchable, {

  name: DS.attr('string')

});

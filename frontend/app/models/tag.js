import DS from 'ember-data';
import Colorable from 'flaredown/mixins/colorable';
import Searchable from 'flaredown/mixins/searchable';

export default DS.Model.extend(Colorable, Searchable, {
  name: DS.attr('string'),

  colorId: '35',
});

import DS from 'ember-data';
import Colorable from 'flaredown/mixins/colorable';

export default DS.Model.extend(Colorable, {
  name: DS.attr('string'),

  colorId: '35',
});

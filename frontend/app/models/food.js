import DS from 'ember-data';
import Typeable from 'flaredown/mixins/typeable';
import Colorable from 'flaredown/mixins/colorable';

export default DS.Model.extend(Typeable, Colorable, {
  name: DS.attr('string'),

  colorId: '35',
});

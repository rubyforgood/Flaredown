import DS from 'ember-data';
import Colorable from 'flaredown/mixins/colorable';
import NestedDestroyable from 'flaredown/mixins/nested-destroyable';

export default DS.Model.extend(Colorable, NestedDestroyable, {

  position: DS.attr('number'),
  checkin: DS.belongsTo('checkin'),

});

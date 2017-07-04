import DS from 'ember-data';
import Typeable from 'flaredown/mixins/typeable';
import Colorable from 'flaredown/mixins/colorable';
import Searchable from 'flaredown/mixins/searchable';

export default DS.Model.extend(Typeable, Colorable, Searchable, {
  usersCount: DS.attr('number'),
});

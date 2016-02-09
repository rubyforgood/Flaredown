import DS from 'ember-data';
import ColorableMixin from 'flaredown/mixins/colorable';
import Searchable from 'flaredown/mixins/searchable';

export default DS.Model.extend(ColorableMixin, Searchable, {
});

import DS from 'ember-data';
import Ember from 'ember';
import ColorClassesMixin from 'flaredown/mixins/color-classes';

export default DS.Model.extend(ColorClassesMixin, {

  colorId: DS.attr('string')

});

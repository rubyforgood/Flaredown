import DS from 'ember-data';
import Ember from 'ember';

const {
  computed,
} = Ember;

export default DS.Model.extend({
  name: DS.attr('string'),
  series: DS.attr('raw'),
});

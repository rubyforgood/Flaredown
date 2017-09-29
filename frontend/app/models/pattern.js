import DS from 'ember-data';
import Ember from 'ember';

const {
  computed,
} = Ember;

export default DS.Model.extend({
  startAt: DS.attr(),
  endAt: DS.attr(),
  name: DS.attr('string'),
});

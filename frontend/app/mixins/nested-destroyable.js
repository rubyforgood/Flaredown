import DS from 'ember-data';
import Ember from 'ember';

export default Ember.Mixin.create({

  _destroy: DS.attr('string'),
  prepareForDestroy: function() {
    this.set('_destroy', '1');
  },
  isPreparedForDestroy: Ember.computed.equal('_destroy', '1')

});

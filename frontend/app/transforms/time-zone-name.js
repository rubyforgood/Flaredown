import DS from 'ember-data';

export default DS.Transform.extend({
  deserialize(serialized) {
    return serialized.split('_').join(' ');
  },

  serialize(deserialized) {
    return deserialized.split(' ').join('_');
  }
});

import Ember from 'ember';

const {
  Mixin,
  computed,
} = Ember;

export default Mixin.create({
  modelType: computed(function() {
    return this.constructor.modelName;
  }),
});

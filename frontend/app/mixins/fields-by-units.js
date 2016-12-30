import Ember from 'ember';

export default Ember.Mixin.create({
  pressureFieldByUnits(unit) {
    return unit === 'in' ? 'pressureInches' : 'pressure';
  },
});

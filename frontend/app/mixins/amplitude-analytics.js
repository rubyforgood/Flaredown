import Ember from 'ember';

const {
  run,
  Mixin,
  Logger: { debug },
} = Ember;

export default Mixin.create({
  amplitudeLog(...params) {
    run(() => {
      if (typeof amplitude === 'undefined') {
        debug('amplitudeLog:', ...params);
      } else {
        amplitude.getInstance().logEvent(...params); // jshint ignore:line
      }
    });
  },
});

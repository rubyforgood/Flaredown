import Ember from 'ember';

const {
  run,
  Mixin,
  Logger: { debug },
} = Ember;

export default Mixin.create({
  amplitudeLog(...strings) {
    run(() => {
      const eventName = strings.join(' ');

      if (typeof amplitude === 'undefined') {
        debug('amplitudeLog:', eventName);
      } else {
        amplitude.getInstance().logEvent(eventName); // jshint ignore:line
      }
    });
  },
});

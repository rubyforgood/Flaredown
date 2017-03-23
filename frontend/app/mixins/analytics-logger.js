import Ember from 'ember';

const {
  run,
  Mixin,
  Logger: { debug },
} = Ember;

export default Mixin.create({
  analyticsLog(...params) {
    run(() => {
      if (typeof amplitude === 'undefined') {
        debug('amplitudeLog:', ...params);
      } else {
        amplitude.getInstance().logEvent(...params); // jshint ignore:line
      }
    });

    run(() => {
      if (typeof mixpanel === 'undefined') {
        debug('mixpanelLog:', ...params);
      } else {
        mixpanel.track(...params); // jshint ignore:line
      }
    });
  },
});

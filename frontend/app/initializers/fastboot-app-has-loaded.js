import Ember from 'ember';

const {
  get,
  set,
  Route,
} = Ember;

export function initialize(application) {
  application.inject('route', 'fastboot', 'service:fastboot');

  Route.reopen({
    afterModel(_model, transition) {
      this._super(...arguments);

      const fastboot = get(this, 'fastboot');

      if(fastboot && !get(fastboot, 'appHasLoaded')) {
        set(fastboot, 'appHasLoaded', get(this, 'routeName') === get(transition, 'targetName'));
      }
    }
  });
}

export default { initialize };

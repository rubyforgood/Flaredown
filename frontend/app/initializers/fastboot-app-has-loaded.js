import Ember from 'ember';

const {
  get,
  set,
  inject: {
    service
  },
  Route,
} = Ember;

export function initialize() {
  Route.reopen({
    fastboot: service('fastboot'),

    afterModel(_model, transition) {
      if(!get(this, 'fastboot.appHasLoaded')) {
        set(this, 'fastboot.appHasLoaded', get(this, 'routeName') === get(transition, 'targetName'));
      }
    }
  });
}

export default { initialize };

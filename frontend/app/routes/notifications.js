import Ember from 'ember';
import HistoryTrackable from 'flaredown/mixins/history-trackable';

const {
  get,
  inject: {
    service,
  },
  Route
} = Ember;

export default Route.extend(HistoryTrackable, {
  notifications: service('notifications'),

  model() {
    return get(this, 'notifications');
  },
});

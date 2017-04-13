import Ember from 'ember';
import PostableGetable from 'flaredown/mixins/postable-getable';
import HistoryTrackable from 'flaredown/mixins/history-trackable';

const {
  Route,
} = Ember;

export default Route.extend(PostableGetable, HistoryTrackable, {
  model() {
    return this.getPostables(1);
  },
});

import Ember from 'ember';
import HistoryTrackable from 'flaredown/mixins/history-trackable';

const {
  get,
  Route,
} = Ember;

export default Route.extend(HistoryTrackable, {
  model() {
    return get(this, 'store')
      .createRecord(
        'post',
        {
          tagIds: [],
          symptomIds: [],
          conditionIds: [],
          treatmentIds: [],
        }
      );
  },

  historyEntry() {
    return null;
  },
});

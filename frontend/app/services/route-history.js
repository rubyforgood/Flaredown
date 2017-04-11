import Ember from 'ember';

const {
  get,
  Service,
  getProperties,
} = Ember;

export default Service.extend({
  limit: 10,
  history: [],

  pushEntry(entry) {
    const { limit, history } = getProperties(this, 'limit', 'history');

    history.pushObject(entry);

    if (history.length > limit) {
      history.shiftObject();
    }
  },

  popEntry() {
    const history = get(this, 'history');

    if (history.length < 2) {
      return null;
    }

    history.popObject(); //skip current

    return history.popObject() || history.popObject(); //skip nulls, which are present for "skip this route" feature
  },
});

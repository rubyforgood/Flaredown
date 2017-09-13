import Ember from 'ember';
import PickATime from 'ember-cli-pickadate/components/pick-a-time';

const {
  get,
  set,
} = Ember;

export default PickATime.extend({
  didInsertElement() {
    this._super(...arguments);
    let newDate = new Date();
    let options = get(this, 'options') || {};

    newDate.setHours(options.hour, options.mins, 0, 0);
    set(this, 'date', newDate);

    this.updateInputText();
  },
});

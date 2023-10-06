import DS from 'ember-data';
import Ember from 'ember';
import moment from 'moment';

const { get } = Ember;

const BirthDay = Ember.Object.extend({
  toString() {
    return get(this, 'serialized');
  }
});

export default DS.Transform.extend({
  deserialize(serialized) {
    const result = BirthDay.create({ serialized });

    if(serialized) {
      const date = moment(serialized);

      if(date.isValid()) {
        result.set('year', date.format('YYYY'));
        result.set('month', date.format('MM'));
        result.set('day', date.format('DD'));
      }
    }

    return result;
  },

  serialize(birth) {
    return `${get(birth, 'year')}-${get(birth, 'month')}-${get(birth, 'day')}`;
  }
});

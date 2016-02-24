import Ember from 'ember';
import CheckinByDate from 'flaredown/mixins/checkin-by-date';

export default Ember.Component.extend(CheckinByDate, {

  actions: {
    routeToCheckin(date) {
      this.routeToCheckin(date);
    }
  }

});

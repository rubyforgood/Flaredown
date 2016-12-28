import Ember from 'ember';
import CheckinByDate from 'flaredown/mixins/checkin-by-date';

export default Ember.Component.extend(CheckinByDate, {
  classNames: 'navigation-bar',

  actions: {
    // TODO dry this
    goToTodaysCheckin() {
      this.routeToCheckin(moment(new Date()).format("YYYY-MM-DD"));
    },
  },
});

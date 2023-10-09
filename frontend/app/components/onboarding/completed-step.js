import Ember from 'ember';
import CheckinByDate from 'flaredown/mixins/checkin-by-date';
import moment from 'moment';

export default Ember.Component.extend(CheckinByDate, {

  model: Ember.computed.alias('parentView.model'),

  actions: {
    completeStep() {
      this.routeToCheckinsForDate(moment(new Date()).format("YYYY-MM-DD"));
    },

    goBack() {
      this.get('onGoBack')();
    }
  }

});

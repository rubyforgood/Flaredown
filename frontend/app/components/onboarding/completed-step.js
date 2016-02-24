/* global moment */
import Ember from 'ember';
import CheckinByDate from 'flaredown/mixins/checkin-by-date';

export default Ember.Component.extend(CheckinByDate, {

  model: Ember.computed.alias('parentView.model'),

  actions: {
    completeStep() {
      this.routeToCheckin(moment(new Date()).format("YYYY-MM-DD"));
    },

    goBack() {
      this.get('onGoBack')();
    }
  }

});

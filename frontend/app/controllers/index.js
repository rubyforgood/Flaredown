import Ember from 'ember';

export default Ember.Controller.extend({

  actions: {
    routeToCheckin(date) {
      Ember.debug("routeToCheckin: " + date);
    }
  }

});

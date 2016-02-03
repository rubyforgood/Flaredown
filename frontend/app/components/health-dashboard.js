import Ember from 'ember';
import ComponentsRouterMixin from 'flaredown/mixins/components-router';

export default Ember.Component.extend(ComponentsRouterMixin, {

  store: Ember.inject.service(),

  actions: {
    routeToCheckin(date) {
      this.get('store').queryRecord('checkin', {date: date}).then(checkin => {
        Ember.Logger.debug(date);
        if (Ember.isPresent(checkin)) {
          Ember.Logger.debug(checkin.toString());
          this.router().transitionTo('checkin', checkin.get('id'), 'summary');
        } else {
          var newCheckin = this.get('store').createRecord('checkin', {date: new Date(date)});
          newCheckin.save().then(savedCheckin => {
            this.router().transitionTo('checkin', savedCheckin.get('id'), 'start');
          });
        }
      });
    }
  }

});

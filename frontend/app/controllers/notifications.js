import Ember from 'ember';
import BackNavigateable from 'flaredown/mixins/back-navigateable';
import UserNameable from 'flaredown/mixins/user-nameable';

const {
  inject: {
    service
  }
} = Ember;

export default Ember.Controller.extend(BackNavigateable, UserNameable, {
  notifications: service('notifications'),
});

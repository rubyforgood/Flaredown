import Ember from 'ember';
import UserNameable from 'flaredown/mixins/user-nameable';

const {
  computed: {
    alias
  },
  Component,
} = Ember;

export default Component.extend(UserNameable, {
  classNames: ['profile-circle'],
  pictureLetter: alias('session.actualUser.profile.screenName.0'),
});

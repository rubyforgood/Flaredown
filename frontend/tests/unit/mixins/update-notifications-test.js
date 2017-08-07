import Ember from 'ember';
import UpdateNotificationsMixin from 'flaredown/mixins/update-notifications';
import { module, test } from 'qunit';

module('Unit | Mixin | update notifications');

// Replace this with your real tests.
test('it works', function(assert) {
  let UpdateNotificationsObject = Ember.Object.extend(UpdateNotificationsMixin);
  let subject = UpdateNotificationsObject.create();
  assert.ok(subject);
});

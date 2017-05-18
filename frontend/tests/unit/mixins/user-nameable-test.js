import Ember from 'ember';
import UserNameableMixin from 'flaredown/mixins/user-nameable';
import { module, test } from 'qunit';

module('Unit | Mixin | user nameable');

// Replace this with your real tests.
test('it works', function(assert) {
  let UserNameableObject = Ember.Object.extend(UserNameableMixin);
  let subject = UserNameableObject.create();
  assert.ok(subject);
});

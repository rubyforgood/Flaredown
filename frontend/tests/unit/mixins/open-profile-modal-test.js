import Ember from 'ember';
import OpenProfileModalMixin from 'flaredown/mixins/open-profile-modal';
import { module, test } from 'qunit';

module('Unit | Mixin | open profile modal');

// Replace this with your real tests.
test('it works', function(assert) {
  let OpenProfileModalObject = Ember.Object.extend(OpenProfileModalMixin);
  let subject = OpenProfileModalObject.create();
  assert.ok(subject);
});

import Ember from 'ember';
import BackNavigateableMixin from 'flaredown/mixins/back-navigateable';
import { module, test } from 'qunit';

module('Unit | Mixin | back navigateable');

// Replace this with your real tests.
test('it works', function(assert) {
  let BackNavigateableObject = Ember.Object.extend(BackNavigateableMixin);
  let subject = BackNavigateableObject.create();
  assert.ok(subject);
});

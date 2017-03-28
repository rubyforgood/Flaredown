import Ember from 'ember';
import TypeableMixin from 'flaredown/mixins/typeable';
import { module, test } from 'qunit';

module('Unit | Mixin | typeable');

// Replace this with your real tests.
test('it works', function(assert) {
  let TypeableObject = Ember.Object.extend(TypeableMixin);
  let subject = TypeableObject.create();
  assert.ok(subject);
});

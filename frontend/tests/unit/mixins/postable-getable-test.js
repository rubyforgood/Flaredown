import Ember from 'ember';
import PostableGetableMixin from 'flaredown/mixins/postable-getable';
import { module, test } from 'qunit';

module('Unit | Mixin | postable getable');

// Replace this with your real tests.
test('it works', function(assert) {
  let PostableGetableObject = Ember.Object.extend(PostableGetableMixin);
  let subject = PostableGetableObject.create();
  assert.ok(subject);
});

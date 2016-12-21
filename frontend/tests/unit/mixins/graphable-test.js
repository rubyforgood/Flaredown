import Ember from 'ember';
import GraphableMixin from 'flaredown/mixins/graphable';
import { module, test } from 'qunit';

module('Unit | Mixin | graphable');

// Replace this with your real tests.
test('it works', function(assert) {
  let GraphableObject = Ember.Object.extend(GraphableMixin);
  let subject = GraphableObject.create();
  assert.ok(subject);
});

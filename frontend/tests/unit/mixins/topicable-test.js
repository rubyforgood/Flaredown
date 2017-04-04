import Ember from 'ember';
import TopicableMixin from 'flaredown/mixins/topicable';
import { module, test } from 'qunit';

module('Unit | Mixin | topicable');

// Replace this with your real tests.
test('it works', function(assert) {
  let TopicableObject = Ember.Object.extend(TopicableMixin);
  let subject = TopicableObject.create();
  assert.ok(subject);
});

import Ember from 'ember';
import HistoryTrackableMixin from 'flaredown/mixins/history-trackable';
import { module, test } from 'qunit';

module('Unit | Mixin | history trackable');

// Replace this with your real tests.
test('it works', function(assert) {
  let HistoryTrackableObject = Ember.Object.extend(HistoryTrackableMixin);
  let subject = HistoryTrackableObject.create();
  assert.ok(subject);
});

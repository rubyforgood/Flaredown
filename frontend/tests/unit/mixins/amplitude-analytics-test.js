import Ember from 'ember';
import AmplitudeAnalyticsMixin from 'flaredown/mixins/amplitude-analytics';
import { module, test } from 'qunit';

module('Unit | Mixin | amplitude analytics');

// Replace this with your real tests.
test('it works', function(assert) {
  let AmplitudeAnalyticsObject = Ember.Object.extend(AmplitudeAnalyticsMixin);
  let subject = AmplitudeAnalyticsObject.create();
  assert.ok(subject);
});

import Ember from 'ember';
import AnalyticsLoggerMixin from 'flaredown/mixins/analytics-logger';
import { module, test } from 'qunit';

module('Unit | Mixin | analytics logger');

// Replace this with your real tests.
test('it works', function(assert) {
  let AmplitudeAnalyticsObject = Ember.Object.extend(AnalyticsLoggerMixin);
  let subject = AmplitudeAnalyticsObject.create();
  assert.ok(subject);
});

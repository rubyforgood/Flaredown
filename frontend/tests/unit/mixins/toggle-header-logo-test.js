import Ember from 'ember';
import ToggleHeaderLogoMixin from 'flaredown/mixins/toggle-header-logo';
import { module, test } from 'qunit';

module('Unit | Mixin | toggle header logo');

// Replace this with your real tests.
test('it works', function(assert) {
  let ToggleHeaderLogoObject = Ember.Object.extend(ToggleHeaderLogoMixin);
  let subject = ToggleHeaderLogoObject.create();
  assert.ok(subject);
});

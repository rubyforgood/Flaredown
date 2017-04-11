import Ember from 'ember';
import BodyFormatableMixin from 'flaredown/mixins/body-formatable';
import { module, test } from 'qunit';

module('Unit | Mixin | body formatable');

// Replace this with your real tests.
test('it works', function(assert) {
  let BodyFormatableObject = Ember.Object.extend(BodyFormatableMixin);
  let subject = BodyFormatableObject.create();
  assert.ok(subject);
});

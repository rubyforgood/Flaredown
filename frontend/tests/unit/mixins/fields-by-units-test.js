import Ember from 'ember';
import FieldsByUnitsMixin from 'flaredown/mixins/fields-by-units';
import { module, test } from 'qunit';

module('Unit | Mixin | fields by units');

// Replace this with your real tests.
test('it works', function(assert) {
  let FieldsByUnitsObject = Ember.Object.extend(FieldsByUnitsMixin);
  let subject = FieldsByUnitsObject.create();
  assert.ok(subject);
});

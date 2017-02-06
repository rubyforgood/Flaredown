
import { equals } from 'flaredown/helpers/equals';
import { module, test } from 'qunit';

module('Unit | Helper | equals');

// Replace this with your real tests.
test('it works', function(assert) {
  assert.notOk(equals([42]));
  assert.ok(equals([42, 42]));
});


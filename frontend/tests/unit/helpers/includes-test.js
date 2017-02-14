
import { includes } from 'flaredown/helpers/includes';
import { module, test } from 'qunit';

module('Unit | Helper | includes');

// Replace this with your real tests.
test('it works', function(assert) {
  assert.notOk(includes([42]));
  assert.notOk(includes([42, 43]));
  assert.ok(includes([42, 42]));
  assert.ok(includes([42, 42, 43]));
  assert.ok(includes([42, 43, 42]));
});


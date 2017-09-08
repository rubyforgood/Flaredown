import { moduleFor, test } from 'ember-qunit';

moduleFor('controller:notifications', 'Unit | Controller | notifications', {
  // Specify the other units that are required for this test.
  needs: ['service:router-scroll', 'service:route-history', 'service:session']
});

// Replace this with your real tests.
test('it exists', function(assert) {
  let controller = this.subject();
  assert.ok(controller);
});

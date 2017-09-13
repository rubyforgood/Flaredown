import { moduleFor, test } from 'ember-qunit';

moduleFor('controller:posts/profile', 'Unit | Controller | posts/profile', {
  // Specify the other units that are required for this test.
  needs: ['service:router-scroll', 'service:route-history', 'service:session', 'service:notifications']
});

// Replace this with your real tests.
test('it exists', function(assert) {
  let controller = this.subject();
  assert.ok(controller);
});

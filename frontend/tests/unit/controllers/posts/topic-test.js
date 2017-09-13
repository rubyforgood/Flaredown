import { moduleFor, test } from 'ember-qunit';

moduleFor('controller:posts/topic', 'Unit | Controller | posts/topic', {
  // Specify the other units that are required for this test.
  needs: ['service:router-scroll', 'service:route-history', 'service:session', 'service:ajax', 'service:notifications']
});

// Replace this with your real tests.
test('it exists', function(assert) {
  let controller = this.subject();
  assert.ok(controller);
});

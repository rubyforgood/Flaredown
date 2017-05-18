import { moduleFor, test } from 'ember-qunit';

moduleFor('route:notifications', 'Unit | Route | notifications', {
  // Specify the other units that are required for this test.
  needs: ['service:router-scroll']
});

test('it exists', function(assert) {
  let route = this.subject();
  assert.ok(route);
});

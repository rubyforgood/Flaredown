import { moduleFor, test } from 'ember-qunit';

moduleFor('route:posts/index', 'Unit | Route | posts/index', {
  // Specify the other units that are required for this test.
  needs: ['service:router-scroll']
});

test('it exists', function(assert) {
  let route = this.subject();
  assert.ok(route);
});

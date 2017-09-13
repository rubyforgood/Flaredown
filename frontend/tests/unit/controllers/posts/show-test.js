import Ember from 'ember';
import { moduleFor, test } from 'ember-qunit';

const {
  run,
} = Ember;

moduleFor('controller:posts/show', 'Unit | Controller | posts/show', {
  // Specify the other units that are required for this test.
  needs: ['service:router-scroll', 'service:route-history', 'service:session', 'service:ajax', 'service:notifications']
});

// Replace this with your real tests.
test('it exists', function(assert) {
  run.begin();

  let controller = this.subject();

  controller.set('model', {});

  assert.ok(controller);

  run.end();
});

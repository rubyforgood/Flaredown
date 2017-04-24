import { moduleForModel, test } from 'ember-qunit';

moduleForModel('reactable', 'Unit | Model | reactable', {
  // Specify the other units that are required for this test.
  needs: ['model:reaction']
});

test('it exists', function(assert) {
  let model = this.subject();
  // let store = this.store();
  assert.ok(!!model);
});

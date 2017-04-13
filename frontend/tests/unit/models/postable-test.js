import { moduleForModel, test } from 'ember-qunit';

moduleForModel('postable', 'Unit | Model | postable', {
  // Specify the other units that are required for this test.
  needs: ['model:post', 'model:comment']
});

test('it exists', function(assert) {
  let model = this.subject();
  // let store = this.store();
  assert.ok(!!model);
});

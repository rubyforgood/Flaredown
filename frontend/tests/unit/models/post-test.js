import { moduleForModel, test } from 'ember-qunit';

moduleForModel('post', 'Unit | Model | post', {
  // Specify the other units that are required for this test.
  needs: ['model:tag', 'model:symptom', 'model:comment', 'model:condition', 'model:treatment']
});

test('it exists', function(assert) {
  let model = this.subject();
  // let store = this.store();
  assert.ok(!!model);
});

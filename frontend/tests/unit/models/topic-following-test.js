import { moduleForModel, test } from 'ember-qunit';

moduleForModel('topic-following', 'Unit | Model | topic following', {
  // Specify the other units that are required for this test.
  needs: ['model:tag', 'model:symptom', 'model:comment', 'model:condition', 'model:treatment']
});

test('it exists', function(assert) {
  let model = this.subject();
  // let store = this.store();
  assert.ok(!!model);
});

import { moduleForModel, test } from 'ember-qunit';

moduleForModel('oracle-request', 'Unit | Model | oracle request', {
  // Specify the other units that are required for this test.
  needs: ['model:sex', 'model:country']
});

test('it exists', function(assert) {
  let model = this.subject();
  // let store = this.store();
  assert.ok(!!model);
});

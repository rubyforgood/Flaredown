import { moduleForModel, test } from 'ember-qunit';

moduleForModel('harvey-bradshaw-index', 'Unit | Model | harvey bradshaw index', {
  // Specify the other units that are required for this test.
  needs: ['model:checkin']
});

test('it exists', function(assert) {
  let model = this.subject();
  // let store = this.store();
  assert.ok(!!model);
});

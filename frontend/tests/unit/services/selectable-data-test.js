import { moduleFor, test } from 'ember-qunit';
import Country from 'flaredown/models/country';

moduleFor('service:selectable-data', 'Unit | Service | selectable data', {
  // Specify the other units that are required for this test.
  // needs: ['service:foo']
});

test('it returns countries', function(assert) {
  assert.expect(4);
  let service = this.subject();
  service.get('countries').then(countries => {
    assert.ok(countries.length);
    var sample = countries[3];
    assert.ok(Country.detectInstance(sample));
    assert.ok(sample.get('id'));
    assert.ok(sample.get('name'));
  });
});

import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('chart/g-weather', 'Integration | Component | chart/g weather', {
  integration: true
});

test('it renders', function(assert) {

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{chart/g-weather name="some name"}}`);

  assert.equal(this.$().text().trim(), 'some name');
});

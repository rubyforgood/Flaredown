import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('navigation-bar', 'Integration | Component | navigation bar', {
  integration: true
});

test('it renders', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });"

  this.render(hbs`{{navigation-bar}}`);

  assert.equal(this.$().text().trim().replace(/\s{2,}/g,' '), 'Checkins History Settings');
});

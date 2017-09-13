import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('custom-pick-a-time', 'Integration | Component | custom pick a time', {
  integration: true
});

test('it renders', function(assert) {

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{custom-pick-a-time}}`);

  assert.equal(this.$().text().trim().split(' ')[0], '12:00');

  // Template block usage:
  this.render(hbs`
    {{#custom-pick-a-time}}
      template block text
    {{/custom-pick-a-time}}
  `);

  assert.equal(this.$().text().trim().split('\n')[0], 'template block text');
});

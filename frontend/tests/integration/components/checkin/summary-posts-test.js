import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('checkin/summary-posts', 'Integration | Component | checkin/summary posts', {
  integration: true
});

test('it renders', function(assert) {

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{checkin/summary-posts}}`);

  assert.equal(this.$().text().trim(), 'Your daily digest');

  // Template block usage:
  this.render(hbs`
    {{#checkin/summary-posts}}
      template block text
    {{/checkin/summary-posts}}
  `);

  assert.equal(this.$().text().trim(), 'Your daily digest');
});

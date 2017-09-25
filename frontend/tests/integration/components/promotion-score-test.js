import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('promotion-score', 'Integration | Component | promotion score', {
  integration: true
});

test('it renders', function(assert) {

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{promotion-score}}`);

  let result = 'How can we do it better';

  assert.equal(this.$().text().trim().match(result)[0], result);

  // Template block usage:
  this.render(hbs`
    {{#promotion-score}}
      template block text
    {{/promotion-score}}
  `);

  assert.equal(this.$().text().trim().match(result)[0], result);
});

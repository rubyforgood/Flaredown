import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('pattern/create-step', 'Integration | Component | pattern/create step', {
  integration: true
});

test('it renders', function(assert) {

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{pattern/create-step}}`);
  let result = 'Save pattern';

  assert.equal(this.$().text().trim().match(result), result);

  // Template block usage:
  this.render(hbs`
    {{#pattern/create-step}}
      template block text
    {{/pattern/create-step}}
  `);

  assert.equal(this.$().text().trim().match(result), result);
});

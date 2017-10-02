import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('pattern/index-step', 'Integration | Component | pattern/index step', {
  integration: true
});

test('it renders', function(assert) {

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{pattern/index-step}}`);

  assert.equal(this.$().text().trim(), '');

  // Template block usage:
  this.render(hbs`
    {{#pattern/index-step}}
      template block text
    {{/pattern/index-step}}
  `);

  assert.equal(this.$().text().trim(), 'template block text');
});

import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('at-js-autocomplete', 'Integration | Component | at js autocomplete', {
  integration: true
});

test('it renders', function(assert) {

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{at-js-autocomplete}}`);

  assert.equal(this.$().text().trim(), '');

  // Template block usage:
  this.render(hbs`
    {{#at-js-autocomplete}}
      template block text
    {{/at-js-autocomplete}}
  `);

  assert.equal(this.$().text().trim(), 'template block text');
});

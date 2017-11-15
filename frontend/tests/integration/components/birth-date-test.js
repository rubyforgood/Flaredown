import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('birth-date', 'Integration | Component | birth date', {
  integration: true
});

test('it renders', function(assert) {

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });
  const result = "Year, Month, Day";

  this.render(hbs`{{birth-date}}`);

  assert.equal(this.$().text().trim().replace(/\s{2,}/g,', '), result);

  // Template block usage:
  this.render(hbs`
    {{#birth-date}}
      template block text
    {{/birth-date}}
  `);

  assert.equal(this.$().text().trim().replace(/\s{2,}/g,', '), result);
});

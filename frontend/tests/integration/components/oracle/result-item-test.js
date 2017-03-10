import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('oracle/result-item', 'Integration | Component | oracle/result item', {
  integration: true
});

test('it renders', function(assert) {

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{oracle/result-item}}`);

  assert.equal(this.$().text().trim(), '');

  // Template block usage:
  this.render(hbs`
    {{#oracle/result-item}}
      template block text
    {{/oracle/result-item}}
  `);

  assert.equal(this.$().text().trim(), 'template block text');
});

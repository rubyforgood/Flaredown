import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('checkin/multi-select-step', 'Integration | Component | checkin/multi select step', {
  integration: true
});

test('it renders', function(assert) {

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{checkin/multi-select-step}}`);

  assert.equal(this.$().text().trim(), '');

  // Template block usage:
  this.render(hbs`
    {{#checkin/multi-select-step}}
      template block text
    {{/checkin/multi-select-step}}
  `);

  assert.equal(this.$().text().trim(), 'template block text');
});

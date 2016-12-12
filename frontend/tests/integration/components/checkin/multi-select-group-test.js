import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('checkin/multi-select-group', 'Integration | Component | checkin/multi select group', {
  integration: true
});

test('it renders', function(assert) {

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{checkin/multi-select-group}}`);

  assert.equal(this.$().text().trim(), '');

  // Template block usage:
  this.render(hbs`
    {{#checkin/multi-select-group}}
      template block text
    {{/checkin/multi-select-group}}
  `);

  assert.equal(this.$().text().trim(), 'template block text');
});

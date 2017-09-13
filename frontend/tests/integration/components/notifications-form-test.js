import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('notifications-form', 'Integration | Component | notifications form', {
  integration: true
});

test('it renders', function(assert) {

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{notifications-form}}`);
  let result = "Email me when someone responds to my posts";

  assert.equal(this.$().text().trim(), result);

  // Template block usage:
  this.render(hbs`
    {{#notifications-form}}
      template block text
    {{/notifications-form}}
  `);

  assert.equal(this.$().text().trim(), result);
});

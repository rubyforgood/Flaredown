import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('password/expired-token', 'Integration | Component | password/expired token', {
  integration: true
});

test('it renders', function(assert) {
  const textAfterLink = "Make sure to always use the reset link in the latest email!";
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{password/expired-token}}`);

  assert.equal(this.$().text().trim().includes(textAfterLink), true);

  // Template block usage:
  this.render(hbs`
    {{#password/expired-token}}
      template block text
    {{/password/expired-token}}
  `);

  assert.equal(this.$().text().trim().includes(textAfterLink), true);
});

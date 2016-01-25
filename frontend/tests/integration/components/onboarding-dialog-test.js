import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('onboarding-dialog', 'Integration | Component | onboarding dialog', {
  integration: true
});

test('it renders', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });"

  this.render(hbs`{{onboarding-dialog}}`);

  assert.equal(this.$().text().trim(), '');

  // Template block usage:"
  this.render(hbs`
    {{#onboarding-dialog}}
      template block text
    {{/onboarding-dialog}}
  `);

  assert.equal(this.$().text().trim(), 'template block text');
});

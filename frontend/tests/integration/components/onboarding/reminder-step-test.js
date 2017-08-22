import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('onboarding/reminded-step', 'Integration | Component | onboarding/reminded step', {
  integration: true
});

test('it renders', function(assert) {

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{onboarding/reminded-step}}`);

  assert.equal(this.$().text().trim(), '');

  // Template block usage:
  this.render(hbs`
    {{#onboarding/reminded-step}}
      template block text
    {{/onboarding/reminded-step}}
  `);

  assert.equal(this.$().text().trim(), 'template block text');
});

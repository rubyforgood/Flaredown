import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('onboarding/reminder-step', 'Integration | Component | onboarding/reminder step', {
  integration: true
});

test('it renders', function(assert) {

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{onboarding/reminder-step}}`);

  let response = this.$().text().trim().replace(/\s{2,}/g,' ').match(/Don't remind me/)[0];

  assert.equal(response, "Don't remind me");


  // Template block usage:
  this.render(hbs`
    {{#onboarding/reminder-step}}
      template block text
    {{/onboarding/reminder-step}}
  `);

  assert.equal(response, "Don't remind me");
});

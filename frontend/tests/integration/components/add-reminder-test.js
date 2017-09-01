import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('add-reminder', 'Integration | Component | add reminder', {
  integration: true
});

test('it renders', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{add-reminder}}`);

  let response = this.$().text().trim().replace(/\s{2,}/g,' ').match(/Don't remind me/)[0];

  assert.equal(response, "Don't remind me");

  // Template block usage:
  this.render(hbs`
    {{#add-reminder}}
      template block text
    {{/add-reminder}}
  `);

  assert.equal(response, "Don't remind me");
});

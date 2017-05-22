import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('join-footer', 'Integration | Component | join footer', {
  integration: true
});

test('it renders', function(assert) {

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{join-footer}}`);

  assert.equal(this.$().text().trim(), 'Join Flaredown');

  // Template block usage:
  this.render(hbs`
    {{#join-footer}}
      template block text
    {{/join-footer}}
  `);

  assert.equal(this.$().text().trim(), 'Join Flaredown');
});

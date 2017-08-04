import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('nav/discussions-unread', 'Integration | Component | nav/discussions unread', {
  integration: true
});

test('it renders', function(assert) {

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  const re = /CHAT/;

  this.render(hbs`{{nav/discussions-unread}}`);

  assert.deepEqual(re.exec(this.$().text().trim()), ['CHAT']);

  // Template block usage:
  this.render(hbs`
    {{#nav/discussions-unread}}
      template block text
    {{/nav/discussions-unread}}
  `);

  assert.deepEqual(re.exec(this.$().text().trim()), ['CHAT']);
});

import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('posts/activity-notification', 'Integration | Component | posts/activity notification', {
  integration: true
});

test('it renders', function(assert) {

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.set('notification', {
    kind: 'reaction',
    notificateableType: 'post'
  });
  const content = 'undefined person reacted to undefined';

  this.render(hbs`{{posts/activity-notification notification=notification}}`);

  assert.equal(this.$().text().trim(), content);

  // Template block usage:
  this.render(hbs`
    {{#posts/activity-notification}}
      template block text
    {{/posts/activity-notification}}
  `);

  assert.equal(this.$().text().trim(), content);
});

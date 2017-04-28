import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('posts/post-comment', 'Integration | Component | posts/post comment', {
  integration: true
});

test('it renders', function(assert) {

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  const content = 'Add reaction';

  this.render(hbs`{{posts/post-comment}}`);

  assert.equal(this.$().text().trim(), content);

  // Template block usage:
  this.render(hbs`
    {{#posts/post-comment}}
      template block text
    {{/posts/post-comment}}
  `);

  assert.equal(this.$().text().trim(), content);
});

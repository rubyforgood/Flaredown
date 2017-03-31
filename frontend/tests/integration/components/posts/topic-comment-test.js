import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('posts/topic-comment', 'Integration | Component | posts/topic comment', {
  integration: true
});

test('it renders', function(assert) {

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{posts/topic-comment}}`);

  assert.equal(this.$().text().trim(), 'Responded to');

  // Template block usage:
  this.render(hbs`
    {{#posts/topic-comment}}
      template block text
    {{/posts/topic-comment}}
  `);

  assert.equal(this.$().text().trim(), 'Responded to');
});

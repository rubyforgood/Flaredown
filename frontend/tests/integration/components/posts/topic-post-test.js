import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('posts/topic-post', 'Integration | Component | posts/topic post', {
  integration: true
});

test('it renders', function(assert) {

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{posts/topic-post}}`);

  assert.equal(this.$().text().trim(), 'comments');
});

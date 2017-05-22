import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('share-socials', 'Integration | Component | share socials', {
  integration: true
});

test('it renders', function(assert) {

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{share-socials}}`);

  assert.equal(this.$().text().trim().replace(/\s{2,}/g,', '), 'Share, Tweet');

  // Template block usage:
  this.render(hbs`
    {{#share-socials}}
      template block text
    {{/share-socials}}
  `);

  assert.equal(this.$().text().trim().replace(/\s{2,}/g,', '), 'Share, Tweet');
});

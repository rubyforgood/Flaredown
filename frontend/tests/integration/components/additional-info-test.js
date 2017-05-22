import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('additional-info', 'Integration | Component | additional info', {
  integration: true
});

test('it renders', function(assert) {

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{additional-info}}`);

  assert.equal(this.$().text().trim().replace(/\s{2,}/g,', '), 'Design your health profile, Track symptoms and treatments, Share you story');

  // Template block usage:
  this.render(hbs`
    {{#additional-info}}
      template block text
    {{/additional-info}}
  `);



  assert.equal(this.$().text().trim().replace(/\s{2,}/g,', '), 'Design your health profile, Track symptoms and treatments, Share you story');
});

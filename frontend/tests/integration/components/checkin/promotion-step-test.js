import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('checkin/promotion-step', 'Integration | Component | checkin/promotion step', {
  integration: true,
});

test('it renders', function(assert) {

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{checkin/promotion-step}}`);

  let result = 'How likely is it that you would recommend Flaredown to a friend';

  assert.equal(this.$().text().trim().match(result)[0], result);

  // Template block usage:
  this.render(hbs`
    {{#checkin/promotion-step}}
      template block text
    {{/checkin/promotion-step}}
  `);

  assert.equal(this.$().text().trim().match(result)[0], result);
});

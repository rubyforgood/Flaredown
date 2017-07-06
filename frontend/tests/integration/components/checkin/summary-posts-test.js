import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import Ember from 'ember';

moduleForComponent('checkin/summary-posts', 'Integration | Component | checkin/summary posts', {
  integration: true,
  beforeEach: function() {
    this.register('service:store', Ember.Service.extend({
      query(){}
    }));
    // Calling inject puts the service instance in the context of the test,
    // making it accessible as "locationService" within each test
    this.inject.service('store', { as: 'store' });
  }
});

test('it renders', function(assert) {

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{checkin/summary-posts}}`);

  assert.equal(this.$().text().trim(), 'Your daily digest');

  // Template block usage:
  this.render(hbs`
    {{#checkin/summary-posts}}
      template block text
    {{/checkin/summary-posts}}
  `);

  assert.equal(this.$().text().trim(), 'Your daily digest');
});

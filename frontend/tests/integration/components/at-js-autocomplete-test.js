import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('at-js-autocomplete', 'Integration | Component | at js autocomplete', {
  integration: true
});

test('it renders', function(assert) {

  this.set('ajax', {
    session: {
      data: {
        authenticated: {
        },
      },
    },

    request() {
      return {
        then() {
        },
      };
    },
  });

   // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{at-js-autocomplete ajax=ajax}}`);

  assert.equal(this.$().text().trim(), '');
});

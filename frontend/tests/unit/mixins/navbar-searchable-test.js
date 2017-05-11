import Ember from 'ember';
import NavbarSearchableMixin from 'flaredown/mixins/navbar-searchable';
import { module, test } from 'qunit';

module('Unit | Mixin | navbar searcheable');

// Replace this with your real tests.
test('it works', function(assert) {
  let NavbarSearchableObject = Ember.Object.extend(NavbarSearchableMixin);
  let subject = NavbarSearchableObject.create();
  assert.ok(subject);
});

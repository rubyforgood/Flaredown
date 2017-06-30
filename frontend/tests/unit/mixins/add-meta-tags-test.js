import Ember from 'ember';
import AddMetaTagsMixin from 'flaredown/mixins/add-meta-tags';
import { module, test } from 'qunit';

module('Unit | Mixin | add meta tags');

// Replace this with your real tests.
test('it works', function(assert) {
  let AddMetaTagsObject = Ember.Object.extend(AddMetaTagsMixin);
  let subject = AddMetaTagsObject.create();
  assert.ok(subject);
});

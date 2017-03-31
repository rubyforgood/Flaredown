import Ember from 'ember';
import PostableGetable from 'flaredown/mixins/postable-getable';
import AuthenticatedRouteMixin from 'flaredown/mixins/authenticated-route-mixin';

const {
  Route,
} = Ember;

export default Route.extend(PostableGetable, AuthenticatedRouteMixin, {
  model() {
    return this.getPostables(1);
  },
});

import Ember from 'ember';
import PostableGetable from 'flaredown/mixins/postable-getable';

const {
  Route,
} = Ember;

export default Route.extend(PostableGetable, {
  model() {
    return this.getPostables(1);
  },
});

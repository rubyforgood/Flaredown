import Ember from 'ember';
import ENV from 'flaredown/config/environment';

const {
  get,
  computed,
  Mixin,
} = Ember;

export default Mixin.create({
  staticUrl: ENV.staticUrl,

  currentUrl: computed('staticUrl', 'router.url', function() {
    return `${get(this, 'staticUrl')}${get(this, 'router.url')}`;
  }),

  afterModel: function(model) {
    this.setHeadTags(model);
    this._super(...arguments);
  },
});

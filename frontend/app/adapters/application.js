import ActiveModelAdapter from 'active-model-adapter';
import DataAdapterMixin from 'ember-simple-auth/mixins/data-adapter-mixin';

export default ActiveModelAdapter.extend(DataAdapterMixin, {
  authorizer: 'authorizer:devise',

  namespace: 'api',
  coalesceFindRequests: true,

  shouldReloadAll: function() {
    return true;
  },

  shouldBackgroundReloadAll: function() {
    return true;
  },

  shouldReloadRecord: function() {
    return false;
  },

  shouldBackgroundReloadRecord: function() {
    return false;
  }

});


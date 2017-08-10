import Ember from 'ember';
import ActiveModelAdapter from 'active-model-adapter';
import DataAdapterMixin from 'ember-simple-auth/mixins/data-adapter-mixin';
import ENV from 'flaredown/config/environment';

const {
  get,
  inject: {
    service,
  }
} = Ember;


export default ActiveModelAdapter.extend(DataAdapterMixin, {
  authorizer: 'authorizer:devise',
  host: ENV.apiHost,
  namespace: 'api',
  coalesceFindRequests: true,

  fastboot: service(),

  handleResponse(status, headers, payload) {
    const shoebox = get(this, 'fastboot.shoebox');
    let shoeboxStore = shoebox.retrieve('CommonStore');

    if (get(this, 'fastboot.isFastBoot')) {
      if (!shoeboxStore) {
        shoeboxStore = { payloads: [] };
      }

      shoeboxStore.payloads.push(payload);

      shoebox.put('CommonStore', shoeboxStore);
    };

    return this._super(...arguments);
  }
});


export default {
  name: 'injectStoreIntoComponents',

  initialize: function initialize(application) {
    application.inject('component', 'store', 'service:store');
  }
};

export default {
  name: 'injectRouterIntoComponents',

  initialize: function initialize(application) {
    application.inject('component', 'router', 'router:main');
  }
};

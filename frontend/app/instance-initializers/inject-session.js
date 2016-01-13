export default {
  name: 'injectSession',

  initialize: function initialize(application) {
    application.inject('controller', 'session', 'service:session');
    application.inject('component', 'session', 'service:session');
  }
};

export default {
  name: 'steps',

  initialize: function initialize(application) {
    application.inject('route:checkin', 'stepsService', 'service:steps');

    application.inject('component:checkin-dialog', 'stepsService', 'service:steps');
    application.inject('component:checkin/start-step', 'stepsService', 'service:steps');
    application.inject('component:checkin/trackables-step', 'stepsService', 'service:steps');
    application.inject('component:checkin/health-factors-step', 'stepsService', 'service:steps');
  }
};

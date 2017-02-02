export default {
  name: 'chartsVisibility',

  initialize: function initialize(application) {
    application.inject('component:health-chart', 'chartsVisibilityService', 'service:charts-visibility');
    application.inject('component:chart-navigation', 'chartsVisibilityService', 'service:charts-visibility');
    application.inject('component:charts-filter-form', 'chartsVisibilityService', 'service:charts-visibility');
    application.inject('component:checkin/trackables-step', 'chartsVisibilityService', 'service:charts-visibility');
  }
};

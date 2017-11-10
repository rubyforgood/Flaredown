export default {
  name: 'chartsVisibility',

  initialize: function initialize(application) {
    application.inject('component:health-chart', 'chartsVisibilityService', 'service:charts-visibility');
    application.inject('component:chart-navigation', 'chartsVisibilityService', 'service:charts-visibility');
    application.inject('component:checkin/hbi-step', 'chartsVisibilityService', 'service:charts-visibility');
    application.inject('component:checkin/trackables-step', 'chartsVisibilityService', 'service:charts-visibility');
    application.inject('component:checkin/multi-select-group', 'chartsVisibilityService', 'service:charts-visibility');
    application.inject('component:chart/g-hbi', 'chartsVisibilityService', 'service:charts-visibility');
    application.inject('component:chart/g-flat', 'chartsVisibilityService', 'service:charts-visibility');
    application.inject('component:chart/g-weather', 'chartsVisibilityService', 'service:charts-visibility');
    application.inject('component:chart/g-trackable', 'chartsVisibilityService', 'service:charts-visibility');
    application.inject('component:chart/g-blank-flat', 'chartsVisibilityService', 'service:charts-visibility');
    application.inject('component:chart/g-blank-trackable', 'chartsVisibilityService', 'service:charts-visibility');
    application.inject('component:pattern/create-step', 'chartsVisibilityService', 'service:charts-visibility');
  }
};

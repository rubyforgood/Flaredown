import Ember from 'ember';
import AuthenticatedRouteMixin from 'flaredown/mixins/authenticated-route-mixin';

const {
  $,
  Route,
} = Ember;

const CHART_PATH_CLASS = 'charts-path';
const TARGET = 'body';

export default Route.extend(AuthenticatedRouteMixin, {
  activate() {
    $(TARGET).addClass(CHART_PATH_CLASS);
  },

  deactivate() {
    $(TARGET).removeClass(CHART_PATH_CLASS);
  },
});

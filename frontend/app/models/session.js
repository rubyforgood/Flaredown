import DS from 'ember-data';

export default DS.Model.extend({
  baseUrl: DS.attr("string"),
  notificationChannel: DS.attr("string"),
  facebookAppId: DS.attr("string"),
  discourseEnabled: DS.attr("string"),
  discourseUrl: DS.attr("string"),
});

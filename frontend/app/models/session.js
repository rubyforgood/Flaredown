import DS from 'ember-data';

export default DS.Model.extend({
  baseUrl: DS.attr("string"),
  notificationChannel: DS.attr("string"),
  facebookAppId: DS.attr("string"),
});

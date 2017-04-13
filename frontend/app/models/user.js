import DS from 'ember-data';

export default DS.Model.extend({
  //Attributes
  email: DS.attr('string'),
  createdAt: DS.attr('date'),

  //Associations
  profile: DS.belongsTo('profile'),
  topicFollowing: DS.belongsTo('topic-following'),
});

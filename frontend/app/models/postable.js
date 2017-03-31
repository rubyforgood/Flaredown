import DS from 'ember-data';

const {
  Model,
  hasMany,
} = DS;

export default Model.extend({
  posts: hasMany('post', { async: false }),
  comments: hasMany('comment', { async: false }),
});

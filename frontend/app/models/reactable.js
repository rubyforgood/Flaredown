import DS from 'ember-data';

const {
  Model,
  hasMany,
} = DS;

export default Model.extend({
  reactions: hasMany('reaction', { async: false }),
});

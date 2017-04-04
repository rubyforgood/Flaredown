import DS from 'ember-data';
import Topicable from 'flaredown/mixins/topicable';

const {
  attr,
  Model,
} = DS;

export default Model.extend(Topicable, {
  updatedAt: attr('date'),
});

import DS from 'ember-data';
import Ember from 'ember';
import Topicable from 'flaredown/mixins/topicable';

const {
  attr,
  Model,
} = DS;

const {
  computed: {
    alias,
  },
} = Ember;

export default Model.extend(Topicable, {
  updatedAt: attr('date'),

  topicsCount: alias('topics.length'),
});

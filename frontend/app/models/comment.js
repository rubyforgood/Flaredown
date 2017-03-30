import DS from 'ember-data';
import Postable from 'flaredown/models/postable';

const {
  belongsTo,
} = DS;

export default Postable.extend({
  post: belongsTo('post'),
});

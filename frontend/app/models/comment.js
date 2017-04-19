import DS from 'ember-data';
import Typeable from 'flaredown/mixins/typeable';
import Reactable from 'flaredown/models/reactable';
import BodyFormatable from 'flaredown/mixins/body-formatable';

const {
  attr,
  belongsTo,
} = DS;

export default Reactable.extend(Typeable, BodyFormatable, {
  body: attr('string'),
  userName: attr('string'),
  createdAt: attr('date'),
  postableId: attr('string'),

  post: belongsTo('post'),
});

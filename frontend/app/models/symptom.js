import DS from 'ember-data';
import Trackable from 'flaredown/models/trackable';

export default Trackable.extend({

  //Attributes
  name: DS.attr('string')

});

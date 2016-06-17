import DS from 'ember-data';
import RankedEnum from 'flaredown/models/ranked-enum';

export default RankedEnum.extend({

  description: DS.attr('string')

});

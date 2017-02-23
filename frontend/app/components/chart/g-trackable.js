import Ember from 'ember';
import Graphable from 'flaredown/components/chart/graphable';

const {
  $,
  get,
  computed,
  Component,
  isPresent,
  computed: { alias },
} = Ember;

export default Component.extend(Graphable, {
  yRulers: [0, 1, 2, 3, 4],

  name: alias('model.name'),

  points: computed('data', function() {
    return get(this, 'data').filter( (item) => {
      return $.isNumeric(item.y);
    }).map( (item) => {
      let x = get(this, 'xScale')(item.x);
      let y = get(this, 'yScale')(item.y) - 4; // minus radius

      return {
        x,
        y,
        tip: {
          label: item.label,
          x: x - 15,
          y: y - 10
        }
      };
    });
  }),

  yScale: computed('data', function() {
    return d3.scale.linear().range([get(this, 'height') , 0]).domain([-1, 5]);
  }),

  data: computed('checkins', function() {
    var trackable = get(this, 'model');
    var type = get(trackable, 'constructor.modelName');
    var key = type.pluralize();
    var timeline = get(this, 'timeline') || [];

    return timeline.map( (day) => {
      var checkin = get(this, 'checkins').findBy('formattedDate', moment(day).format("YYYY-MM-DD"));

      var coordinate = { x: day, y: null };

      if(isPresent(checkin)) {
        var item = get(checkin, key).findBy(`${type}.id`, get(trackable, 'id'));

        if (isPresent(item) && $.isNumeric(get(item, 'value'))) {
          coordinate.label = get(item, 'value');
          coordinate.y = get(item, 'value');
        }
      }

      return coordinate;
    }).sortBy('x');
  }),
});

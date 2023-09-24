import Ember from 'ember';
import moment from 'moment';
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
      var filteredCheckins = get(this, 'checkins').filter((checkin) => (
        get(checkin, 'formattedDate') === moment(day).format("YYYY-MM-DD")
      ))
      var coordinate = { x: day, y: null };

      if(filteredCheckins.length) {
        var items = filteredCheckins.map(item => (
          get(item, key).findBy(`${type}.id`, get(trackable, 'id'))
        )).filter(Boolean)

        if (items.length) {
          var allItemValues = items.map(item => (get(item, 'value')))
          var averageItemValue = allItemValues.reduce((acc, val) => (acc + val), 0) / allItemValues.length

          if (isPresent(averageItemValue) && $.isNumeric(averageItemValue)) {
            coordinate.label = averageItemValue
            coordinate.y = averageItemValue
          }
        }
      }

      return coordinate;
    }).sortBy('x');
  }),
});

import Ember from 'ember';
import Graphable from 'flaredown/components/chart/graphable';

export default Ember.Component.extend(Graphable, {
  dataYValues: [0, 1, 2, 3, 4],

  points: Ember.computed('data', function() {
    return this.get('data').filter( (item) => {
      return Ember.$.isNumeric(item.y);
    }).map( (item) => {
      let x = this.get('xScale')(item.x);
      let y = this.get('yScale')(item.y) - 4; // minus radius

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

  yScale: Ember.computed('data', function() {
    return d3.scale.linear().range([this.get('height') , 0]).domain([-1, 5]);
  }),

  data: Ember.computed('checkins', function() {
    var trackable = this.get('model');
    var type = trackable.get('constructor.modelName');
    var key = type.pluralize();
    var timeline = this.get('timeline') || [];
    return timeline.map( (day) => {
      var checkin = this.get('checkins').findBy('formattedDate', moment(day).format("YYYY-MM-DD"));

      var coordinate = { x: day, y: null };

      if(Ember.isPresent(checkin)) {
        var item = checkin.get(key).findBy(`${type}.id`, trackable.get('id'));

        if (Ember.isPresent(item) && Ember.$.isNumeric(item.get('value'))) {
          coordinate.label = item.get('value');
          coordinate.y = item.get('value');
        }
      }

      return coordinate;
    }).sortBy('x');
  }),
});

import Ember from 'ember';
import Graphable from 'flaredown/components/chart/graphable';

export default Ember.Component.extend(Graphable, {
  init() {
    this._super(...arguments);

    Ember.run.scheduleOnce('afterRender', () => {
      this.drawAxis();
    });
  },

  xAxis: Ember.computed('xScale', function() {
    return(
      d3
        .svg
        .axis()
        .scale(this.get('xScale'))
        .orient('bottom')
        .ticks(0)
    );
  }),

  xAxisTransform: Ember.computed('height', 'startAt', 'data', function() {
    return `translate(${ - this.get('xScale')( this.get('startAt') )},${this.get('height')})`;
  }),

  drawAxis: Ember.observer('xAxis', function() {
    if (Ember.isPresent(this.get('data'))) {
      d3.select(`g#x-axis-${this.get('xAxisElementId')}`).call(this.get('xAxis'));
    }
  }),

  markers: Ember.computed('data', function() {
    return this.get('data').filter( (item) => {
      return item.y === true;
    }).map( (item) => {
      return {
        x: this.get('xScale')(item.x) - 20 ,
        y: this.get('yScale')(2.5),
        tip: {
          label: item.label,
          x: this.get('xScale')(item.x) - 15,
          y: this.get('yScale')(item.y) - 15
        }
      };
    });
  }),

  xAxisElementId: Ember.computed('model', function() {
    return `${this.get('model.constructor.modelName')}-${this.get('model.id')}`;
  }),

  yScale: Ember.computed('data', function() {
    return d3.scale.linear().range([this.get('height') , 0]).domain([-1, 5]);
  }),

  data: Ember.computed('checkins', function() {
    var trackable = this.get('model');
    var type = trackable.get('constructor.modelName');
    var key = type.pluralize();
    var timeline = this.get('timeline') || [];

    return timeline.map(day => {
      var checkin = this.get('checkins').findBy('formattedDate', moment(day).format("YYYY-MM-DD"));
      var coordinate = { x: day, y: null };

      if(Ember.isPresent(checkin)) {
        var item = checkin.get(key).findBy(`${type}.id`, trackable.get('id'));

        if(Ember.isPresent(item) && item.get('isTaken') ) {
          coordinate.label = item.get('value');
          coordinate.y = true;
        }
      }

      return coordinate;
    }).sortBy('x');
  }),

  actions: {
    openMarkerTooltip(marker) {
      this.set('openMarkerTooltip', true);
      this.set('currentMarker', marker);
    },

    closeMarkerTooltip() {
      this.set('openMarkerTooltip', false);
      this.set('currentMarker', null);
    }
  },
});

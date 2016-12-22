import Ember from 'ember';
import Graphable from './mixins/graphable';

export default Ember.Component.extend(Graphable, {
  type: 'line',
  isLineSerie: Ember.computed.equal('type', 'line'),
  isSymbolSerie: Ember.computed.equal('type', 'symbol'),

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

  points: Ember.computed('data', function() {
    return this.get('data').filter( (item) => {
      return Ember.$.isNumeric(item.y);
    }).map( (item) => {
      return {
        x: this.get('xScale')(item.x),
        y: this.get('yScale')(item.y),
        tip: {
          label: item.label,
          x: this.get('xScale')(item.x) - 15,
          y: this.get('yScale')(item.y) - 10
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
    return timeline.map( (day) => {
      var checkin = this.get('checkins').findBy('formattedDate', moment(day).format("YYYY-MM-DD"));

      var coordinate = { x: day, y: null };

      if(Ember.isPresent(checkin)) {
        var item = checkin.get(key).findBy(`${type}.id`, trackable.get('id'));

        if(Ember.isPresent(item) && (Ember.isPresent(item.get('value')) || item.get('isTaken')) ) {
          coordinate.label = item.get('value');

          if(Ember.$.isNumeric(item.get('value')) ) {
            coordinate.y = item.get('value');
          } else if (Ember.isEqual(item.get('isTaken'), true)) {
            coordinate.y = true;
          }
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

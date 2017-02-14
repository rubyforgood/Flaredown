import Ember from 'ember';
import Graphable from 'flaredown/components/chart/graphable';

const {
  get,
  set,
  computed,
  Component,
  isPresent,
  computed: { alias },
} = Ember;

export default Component.extend(Graphable, {
  markerRadius: 7,

  name: alias('model.name'),

  halfHeight: computed('height', function() {
    return get(this, 'yScale')(0);
  }),

  markers: computed('data', function() {
    return(
      get(this, 'data')
        .filter(item => item.y === true)
        .map(item => ({
          x: get(this, 'xScale')(item.x),
          y: get(this, 'yScale')(0) - Math.ceil(get(this, 'markerRadius') / 2),
          tip: {
            label: item.label,
            x: get(this, 'xScale')(item.x) - 15,
            y: get(this, 'yScale')(item.y) - get(this, 'markerRadius') / 3,
          }
        }))
    );
  }),

  xAxisElementId: computed('model', function() {
    return `${get(this, 'model.constructor.modelName')}-${get(this, 'model.id')}`;
  }),

  yScale: computed('data', function() {
    return d3.scale.linear().range([get(this, 'height') , 0]).domain([-1, 1]);
  }),

  data: computed('checkins', function() {
    var type = get(this, 'model.constructor.modelName');
    var key = type.pluralize();
    var timeline = get(this, 'timeline') || [];

    return timeline.map(day => {
      var checkin = get(this, 'checkins').findBy('formattedDate', moment(day).format("YYYY-MM-DD"));
      var coordinate = { x: day, y: null };

      if(isPresent(checkin)) {
        let item = key === 'tags' ?
          get(checkin, key).findBy('name', get(this, 'model.name'))
        :
          get(checkin, key).findBy(`${type}.id`, get(this, 'model.id'));

        if (isPresent(item) && (get(item, 'isTaken') || key === 'tags')) {
          coordinate.label = get(item, 'value');
          coordinate.y = true;
        }
      }

      return coordinate;
    }).sortBy('x');
  }),

  actions: {
    openMarkerTooltip(marker) {
      set(this, 'openMarkerTooltip', true);
      set(this, 'currentMarker', marker);
    },

    closeMarkerTooltip() {
      set(this, 'openMarkerTooltip', false);
      set(this, 'currentMarker', null);
    }
  },
});

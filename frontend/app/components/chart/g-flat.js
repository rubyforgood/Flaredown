import Ember from 'ember';
import moment from 'moment';
import Graphable from 'flaredown/components/chart/graphable';

const {
  get,
  set,
  computed,
  Component,
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
    const modelId = get(this, 'model.id');
    const modelName = get(this, 'name');

    return timeline.map(day => {
      var filteredCheckins = get(this, 'checkins').filter((checkin) => (
        get(checkin, 'formattedDate') === moment(day).format("YYYY-MM-DD")
      ))
      var coordinate = { x: day, y: null };

      if(filteredCheckins.length) {
        var items = key === 'tags' || key === 'foods' ?
          filteredCheckins.map(item => (
            get(item, key).findBy('name', modelName)
          )).filter(Boolean)
        :
          filteredCheckins.map(item => (
            get(item, key).findBy(`${type}.id`, modelId)
          )).filter(Boolean)

        var takenItems = items.filter((item) => (get(item, 'isTaken')))

        if (items.length && (takenItems.length || key === 'tags' || key === 'foods')) {
          var itemValues = [...takenItems, ...items].map(item => (get(item, 'value'))).filter(Boolean)

          var label = itemValues.join(", ")

          coordinate.label = label;
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

import Ember from 'ember';

const {
  get,
  set,
  inject: { service },
  Service,
  observer,
  isPresent,
  getProperties,
  setProperties,
} = Ember;

export default Service.extend({
  store: service(),
  session: service(),

  payload: {},
  storageKey: 'chartsVisibilityV2', // increase version on schema change
  hiddenCharts: [],
  patternIncludes: [],
  fetchOnlyQuery: {},
  payloadVersion: 1,
  visibilityFilter: {},
  visibleChartsCount: 0,

  observeVisibilityChanges: observer(
    'payload.tags.@each.visible',
    'payload.foods.@each.visible',
    'payload.symptoms.@each.visible',
    'payload.conditions.@each.visible',
    'payload.treatments.@each.visible',
    'payload.weathersMeasures.@each.visible',
    'payload.harveyBradshawIndices.@each.visible',
    function() {
      const payload = get(this, 'payload');

      let hiddenCharts = [];
      let patternIncludes = [];
      let fetchOnlyQuery = {};
      let visibilityFilter = {};
      let visibleChartsCount = 0;

      Object
        .keys(payload)
        .forEach(category => {
          let categoryCharts = payload[category];

          visibilityFilter[category] = {};

          Object
            .keys(categoryCharts)
            .forEach(chart => {
              let chart_id = categoryCharts[chart].id;

              if(category === 'weathersMeasures') {
                chart_id = chart_id == 1 ? 'humidity' : 'pressure';
              }

              patternIncludes.pushObject({
                id: chart_id,
                category,
                label: categoryCharts[chart].label,
              });

              if (categoryCharts[chart].visible) {
                visibleChartsCount += 1;

                visibilityFilter[category][categoryCharts[chart].label] = true;

                if (!fetchOnlyQuery[category]) {
                  fetchOnlyQuery[category] = [];
                }

                fetchOnlyQuery[category].pushObject(categoryCharts[chart].id);
              } else if(isPresent(categoryCharts[chart].label)) {

                hiddenCharts.pushObject({
                  id: categoryCharts[chart].id,
                  category,
                  label: categoryCharts[chart].label,
                });
              }
            });
        });

      setProperties(this, {
        fetchOnlyQuery,
        visibilityFilter,
        visibleChartsCount,
        hiddenCharts: hiddenCharts.sortBy('label'),
        patternIncludes: patternIncludes.sortBy('label'),
      });

      this.updateStorage();
    }
  ),

  init() {
    this._super(...arguments);

    let payload = this.getFromStorage();

    if (payload) {
      set(this, 'payload', payload);

      this.observeVisibilityChanges();
    } else {
      if(get(this, 'session.isAuthenticated')) {
        this.refresh();
      }
    }
  },

  setVisibility(value, categoryName, label) {
    let payloadCategoryName = `payload.${categoryName}`;
    let category = get(this, payloadCategoryName) || [];

    category.forEach(chart => {
      if (chart.label === label) {
        set(chart, 'visible', value);
      }
    });

    let payloadVersion = get(this, 'payloadVersion') + 1;

    setProperties(this, {
      payloadVersion,
      payloadDirection: value,
      [payloadCategoryName]: category,
    });
  },

  getFromStorage() {
    const storageKey = get(this, 'storageKey');

    return localStorage[storageKey] && JSON.parse(localStorage[storageKey]);
  },

  updateStorage() {
    const { storageKey, payload } = getProperties(this, 'storageKey', 'payload');

    localStorage[storageKey] = JSON.stringify(payload);
  },

  refresh() {
    get(this, 'store')
      .queryRecord('chart-list', {})
      .then(responce => {
        let payload = this.mergeChartsVisibility(get(responce, 'payload'), this.getFromStorage() || {});
        let payloadVersion = get(this, 'payloadVersion') + 1;

        setProperties(this, { payload, payloadVersion });

        this.updateStorage();
      });
  },

  mergeChartsVisibility(allowedCharts, savedChartsVisibility) {
    let result = {};

    Object
      .keys(allowedCharts)
      .forEach(category => {
        result[category] = [];

        allowedCharts[category].forEach(chart => {
          const [id, label, visibility] = chart;

          let savedCategory = savedChartsVisibility[category];
          let chartWasPresent = savedCategory && savedCategory.findBy('id', id);

          result[category].pushObject({
            id,
            label,
            visible: chartWasPresent ? chartWasPresent.visible : visibility,
          });
        });
      });

    return result;
  },
});

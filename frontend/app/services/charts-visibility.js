import Ember from 'ember';

const {
  get,
  set,
  inject,
  Service,
  observer,
  isPresent,
} = Ember;

export default Service.extend({
  store: inject.service(),
  payload: {},
  hiddenCharts: [],
  visibilityFilter: {},
  visibleChartsCount: 0,

  observeVisibilityChanges: observer(
    'payload.symptoms.@each.visible',
    'payload.conditions.@each.visible',
    'payload.treatments.@each.visible',
    'payload.weathersMesures.@each.visible',
    function() {
      const payload = get(this, 'payload');

      let count = 0;
      let filter = {};
      let hiddenCharts = [];

      Object
        .keys(payload)
        .forEach(category => {
          let categoryCharts = payload[category];

          filter[category] = {};

          Object
            .keys(categoryCharts)
            .forEach(chart => {
              if (categoryCharts[chart].visible) {
                count += 1;

                filter[category][categoryCharts[chart].label] = true;
              } else if(isPresent(categoryCharts[chart].label)) {
                hiddenCharts.pushObject({
                  category,
                  label: categoryCharts[chart].label,
                });
              }
            });
        });

      set(this, 'hiddenCharts', hiddenCharts.sortBy('label'));
      set(this, 'visibilityFilter', filter);
      set(this, 'visibleChartsCount', count);

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
      this.refresh();
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

    set(this, payloadCategoryName, category);
  },

  getFromStorage() {
    return localStorage.chartsVisibility && JSON.parse(localStorage.chartsVisibility);
  },

  updateStorage() {
    localStorage.chartsVisibility = JSON.stringify(get(this, 'payload'));
  },

  refresh() {
    get(this, 'store')
      .queryRecord('chart-list', {})
      .then(responce => {
        let payload = this.mergeChartsVisibility(get(responce, 'payload'), this.getFromStorage() || {});

        set(this, 'payload', payload);

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
          let savedCategory = savedChartsVisibility[category];
          let chartWasPresent = savedCategory && savedCategory.findBy('label', chart);

          result[category].pushObject({
            label: chart,
            visible: !chartWasPresent || chartWasPresent.visible,
          });
        });
      });

    result.weathersMesures = [];

    ['Avg daily humidity', 'Avg daily atmospheric pressure'].forEach(chart => {
      let savedCategory = savedChartsVisibility.weathersMesures;
      let chartWasPresent = savedCategory && savedCategory.findBy('label', chart);

      result.weathersMesures.pushObject({
        label: chart,
        visible: !chartWasPresent || chartWasPresent.visible,
      });
    });

    return result;
  },
});

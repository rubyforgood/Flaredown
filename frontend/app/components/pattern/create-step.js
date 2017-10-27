import Ember from 'ember';
import ChartDataRetrieve from 'flaredown/mixins/chart/chart-data-retrieve';
import { translationMacro as t } from "ember-i18n";

const {
  get,
  set,
  computed,
  computed: {
    not
  },
  inject: { service },
  observer,
  setProperties,
  Component,
  A,
} = Ember;

export default Component.extend(ChartDataRetrieve, {
  i18n: service(),
  store: service(),

  model: null,
  maxTrackables: 10,
  showMessage: false,

  classNames: ['flaredown-white-box'],
  selectLabel: t("history.step.creation.selectLabel"),
  deleteText: t("history.step.creation.deleteText"),
  saveText: t("history.step.creation.buttonText"),
  maxTrackablesText: t("history.step.creation.maxTrackablesText"),

  disableSaveBtn: not('model.includes.length'),

  chartEnablerPlaceholder: computed('isChartEnablerDisabled', function() {
    return get(this, 'isChartEnablerDisabled') ? 'No items to add' : 'Add symptoms, treatments and more...';
  }),

  init() {
    this._super(...arguments);

    get(this, 'store')
      .queryRecord('chart-list', {})
      .then((res) => {
        set(this, 'payload', get(res, 'payload'));
    });
  },

  didReceiveAttrs() {
    this._super(...arguments);

    const model = get(this, 'model');
    const store = get(this, 'store');

    if(model === null && store) {
      set(this, 'model', store.createRecord('pattern'));
    }
  },

  maxTrackablesObserver: observer('model.includes.length', function() {
    let length = get(this, 'model.includes.length');
    const maxTrackables = get(this, 'maxTrackables');

    if(length >= maxTrackables) {
      setProperties(this, { showMessage: true, disableSaveBtn: true });
    } else {
      setProperties(this, { showMessage: false, disableSaveBtn: false });
    }
  }),

  patternIncludesObserver: observer('payload', function() {
    const patternIncludes = A([]);
    const payload = get(this, 'payload');

    Object
      .keys(payload)
      .forEach(category => {
        const categoryCharts = payload[category];

        categoryCharts.forEach(chart => {
            let chart_id = chart[0];

            if(category === 'weathersMeasures') {
              chart_id = chart_id == 1 ? 'humidity' : 'pressure';
            }

            patternIncludes.pushObject({
              id: chart_id,
              category,
              label: chart[1],
            });
          });
      });

    set(this, 'patternIncludes', patternIncludes);
  }),

  patternOptionsObserver: observer('patternIncludes', 'model.includes', function() {
    const includes = get(this, 'model.includes');
    const patternIncludes = get(this, 'patternIncludes');

    set(this, 'options', A(patternIncludes.filter((pattern) => {
      return includes.filter((inc) => {
        return inc.id == pattern.id && inc.category == pattern.category;
      }).length === 0;
    })));
  }),

  actions: {
    handleChange(obj) {
      const maxTrackables = get(this, 'maxTrackables');
      const includes = get(this, 'model.includes');
      const options = get(this, 'options');

      const exist = includes.find((i) => {
        return get(i, 'id') == get(obj, 'id') && get(i, 'category') == get(obj, 'category');
      });

      options.removeObject(obj);

      if(exist == null && includes.length < maxTrackables) {
        includes.pushObject(obj);
      } else {
        set(this, 'showMessage', true);
      }
    },

    clicked(obj) {
      get(this, 'model.includes').removeObject(obj);

      let options = get(this, 'options');

      const exist = options.find((i) => {
        return get(i, 'id') == get(obj, 'id') && get(i, 'category') == get(obj, 'category');
      });

      if(exist == null && obj.category !== 'weathersMeasures') {
        options.pushObject(obj);
      }
    },

    savePattern() {
      get(this, 'model').save().then(() => {
        this.sendAction('onSaved');
      });
    },

    deletePattern() {
      get(this, 'model').destroyRecord().then(() => {
        this.sendAction('onSaved');
      });
    },

    cancel() {
      get(this, 'model').deleteRecord();

      this.sendAction('onCanceled');
    }
  },
});

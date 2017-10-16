import Ember from 'ember';
import ChartDataRetrieve from 'flaredown/mixins/chart/chart-data-retrieve';
import { translationMacro as t } from "ember-i18n";

const {
  get,
  set,
  computed,
  computed: {
    alias,
    not
  },
  inject: { service },
  observer,
  run: {
    debounce,
    scheduleOnce,
  },
  getProperties,
  setProperties,
  Component,
  A,
} = Ember;

export default Component.extend(ChartDataRetrieve, {
  i18n: service(),

  model: null,
  maxTrackables: 3,
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

  didReceiveAttrs() {
    this._super(...arguments);

    const model = get(this, 'model');

    if(model === null) {
      set(this, 'model', get(this, 'store').createRecord('pattern'));
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

  actions: {
    handleChange(obj) {
      const maxTrackables = get(this, 'maxTrackables');
      const includes = get(this, 'model.includes');

      get(this, 'patternIncludes').removeObject(obj);

      if(!includes.includes(obj)) {
        includes.pushObject(obj);
      }

      // if(!includes.includes(obj) && includes.length <= maxTrackables) {
      //   includes.pushObject(obj);
      // } else {
      //   set(this, 'showMessage', true);
      // }
    },

    clicked(obj) {
      get(this, 'model.includes').removeObject(obj);

      let includes = get(this, 'patternIncludes');

      if(obj.category !== 'weathersMeasures') {
        includes.pushObject(obj);
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
      });;
    },

    cancel() {
      this.sendAction('onCanceled');
    }
  },
});

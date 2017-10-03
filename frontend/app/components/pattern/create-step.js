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
  Component,
  A,
} = Ember;

export default Component.extend(ChartDataRetrieve, {
  i18n: service(),

  model: null,

  classNames: ['flaredown-white-box'],
  selectLabel: t("history.step.creation.selectLabel"),
  deleteText: t("history.step.creation.deleteText"),
  saveText: t("history.step.creation.buttonText"),

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

  actions: {
    handleChange(obj) {
      const includes = get(this, 'model.includes');

      get(this, 'patternIncludes').removeObject(obj);

      if(!includes.includes(obj)) {
        includes.pushObject(obj);
      }
    },

    clicked(obj) {
      get(this, 'model.includes').removeObject(obj);

      let includes = get(this, 'patternIncludes');
      includes.pushObject(obj);
    },

    savePattern() {
      get(this, 'model').save().then(() => {
        this.sendAction('onSaved');
      });
    },

    deletePattern() {
      get(this, 'model').destroyRecord();
    },

    cancel() {
      this.sendAction('onCanceled');
    }
  },
});

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

  classNames: ['flaredown-white-box'],
  objects: A([]),
  selectLabel: t("history.step.creation.selectLabel"),
  deleteText: t("history.step.creation.deleteText"),
  saveText: t("history.step.creation.buttonText"),

  disableSaveBtn: not('objects.length'),

  chartEnablerPlaceholder: computed('isChartEnablerDisabled', function() {
    return get(this, 'isChartEnablerDisabled') ? 'No items to add' : 'Add symptoms, treatments and more...';
  }),

  actions: {
    handleChange(obj) {
      let objects = get(this, 'objects');

      if(!objects.includes(obj)) {
        objects.pushObject(obj);
      }
    },

    clicked(obj) {
      get(this, 'objects').removeObject(obj);
    },

    savePattern() {
      set(this, 'startSaving', true);
      const query = {
        name: get(this, 'name'),
        includes: get(this, 'objects'),
      };

      get(this, 'store').createRecord('pattern', query).save();
      set(this, 'startSaving', false);
    },

    deletePattern() {
    }
  },
});

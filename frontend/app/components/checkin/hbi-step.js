import Ember from 'ember';

const {
  get,
  set,
  Component,
  computed: { alias },
} = Ember;

export default Component.extend({
  classNames: ['hbi-step'],

  checkin: alias('parentView.model.checkin'),

  didReceiveAttrs() {
    this._super(...arguments);

    const checkin = get(this, 'checkin');

    get(checkin, 'harveyBradshawIndex')
      .then(
        hbi => set(this, 'hbi', hbi || get(this, 'store').createRecord('harveyBradshawIndex', { checkin }))
      );
  },

  actions: {
    save() {
      get(this, 'hbi').save();
    },

    goBack() {
      this.get('onGoBack')();
    },

    selectOption(field, option) {
      set(this, `hbi.${field}`, option.value);
    },

    completeStep() {
      this.get('onStepCompleted')();
    },
  },
});

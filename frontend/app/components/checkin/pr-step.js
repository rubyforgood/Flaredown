import Ember from 'ember';
import { translationMacro as t } from "ember-i18n";

const {
  get,
  set,
  computed,
  computed: {
    alias,
  },
  inject: {
    service,
  },
  Component
} = Ember;

export default Component.extend({
  i18n: service(),
  ajax: service(),

  classNames: ['checkinPrStep'],
  checkin: alias('parentView.model.checkin'),

  didReceiveAttrs() {
    this._super(...arguments);

    const checkin = get(this, 'checkin');
    const pr = get(checkin, 'promotionRate');

    set(this, 'pr', pr || get(this, 'store').createRecord('promotionRate', { checkin }));
  },

  feedBackLabel: t("step.checkin.promotion_rate.feedBackLabel"),
  prBody: t("step.checkin.promotion_rate.body"),

  rates: [1,2,3,4,5,6,7,8,9,10],

  prRates: computed('rates', function() {
    const rates = get(this, 'rates');

    return rates;
  }),

  actions: {
    sendRate(value) {
      const pr = get(this, 'pr');

      set(pr, 'score', value);
      pr.save();
    },

    sendFeedback() {
    }
  }
});

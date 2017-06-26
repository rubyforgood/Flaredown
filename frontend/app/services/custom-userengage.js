import Userengage from 'ember-userengage/services/userengage';

export default Userengage.extend({
  initialize(options = {}) {
    if (typeof FastBoot === 'undefined') {
      this._super(options);
    }
  },

  pageHit() {
    if (typeof FastBoot === 'undefined') {
      this._super();
    }
  },

  refresh(options) {
    if (typeof FastBoot === 'undefined') {
      this._super(options);
    }
  },

  destroy() {
    if (typeof FastBoot === 'undefined') {
      this._super();
    }
  }
});

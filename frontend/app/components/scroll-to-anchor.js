import Ember from 'ember';

const {
  $,
  get,
  Component,
  run: { schedule }
} = Ember;

export default Component.extend({

  didRender() {
    this._super(...arguments);

    schedule('afterRender', this, this.scrollToAnchor);
  },

  scrollToAnchor() {
    const anchor = get(this, 'anchor');

    if(anchor) {
      const $anchorId = $(`#${anchor}`);
      const $anchorClass = $(`.${anchor}`);

      if($anchorId.length > 0) { $('body').animate({ scrollTop: $anchorId.offset().top }, 'slow'); }
      if($anchorClass.length > 0) { $('body').animate({ scrollTop: $anchorClass.offset().top }, 'slow'); }
    }
  },
});

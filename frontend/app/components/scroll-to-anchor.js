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
      const $anchor = $(`#${anchor}`);

      if($anchor.length > 0) { $('body').animate({ scrollTop: $anchor.offset().top }, 'slow'); }
    }
  },
});

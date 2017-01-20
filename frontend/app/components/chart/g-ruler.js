import Ember from 'ember';

let { Component, computed } = Ember;

export default Component.extend({
  unit: '',
  tagName: 'g',
  labelSize: 12,
  linesOffset: 0,

  init() {
    this._super(...arguments);

    Ember.run.scheduleOnce('afterRender', () => {
      const labelsBox = this.$().find('.ruler-labels')[0].getBBox();

      this.set('linesOffset', labelsBox.x + labelsBox.width);
    });
  },

  rulers: computed('dataYValues', function() {
    return (this.get('dataYValues') || [])
      .map(item => {
        const lineY = this.get('yScale')(item);

        return {
          lineY,
          label: `${item}${this.get('unit')}`,
          labelY: lineY + this.get('labelSize') / 2 - 2,
        };
      });
  }),
});

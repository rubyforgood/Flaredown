import Ember from 'ember';

let {
  set,
  computed,
  Component,
  getProperties,
} = Ember;

export default Component.extend({
  unit: '',
  tagName: 'g',
  labelSize: 12,
  linesOffset: 0,

  init() {
    this._super(...arguments);

    Ember.run.scheduleOnce('afterRender', () => {
      const labelsBox = this.$().find('.ruler-labels')[0].getBBox();

      set(this, 'linesOffset', labelsBox.x + labelsBox.width);
    });
  },

  rulers: computed('yRulers', function() {
    const {
      unit,
      yScale,
      labelSize,
      yRulers,
    } = getProperties(this, 'unit', 'yScale', 'labelSize', 'yRulers');

    return (yRulers || [])
      .map(item => {
        const lineY = yScale(item);

        return {
          lineY,
          label: `${item}${unit}`,
          labelY: lineY + labelSize / 2 - 2,
        };
      });
  }),
});

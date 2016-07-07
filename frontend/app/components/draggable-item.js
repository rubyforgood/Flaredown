import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['draggable-item'],

  classNameBindings: ['dragging'],
  dragging: false,

  attributeBindings: ['draggable'],
  draggable: 'true',

  dragStart(event) {
    this.set('dragging', true);
    return event.dataTransfer.setData('text/plain', this.get('itemId'));
  },
  dragEnd() {
    this.set('dragging', false);
  }
});

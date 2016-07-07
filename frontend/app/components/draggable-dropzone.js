import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['draggable-dropzone'],
  classNameBindings: ['dragClass'],
  dragClass: 'deactivated',

  dragLeave(event) {
    event.preventDefault();
    this.set('dragClass', 'deactivated');
  },

  dragEnter(event) {
    event.preventDefault();
    this.set('dragClass', 'activated');
  },

  dragOver(event) {
    event.preventDefault();
  },

  drop(event) {
    let draggedData = event.dataTransfer.getData('text/plain');
    this.get('onDropped')(draggedData, this.get('itemId'));
    this.set('dragClass', 'deactivated');
  }
});

import Ember from 'ember';

export default Ember.Mixin.create( {
  attributeBindings: [ 'draggable' ],
  draggable: true,

  onDragStart: Ember.on('dragStart', function(event) {
    this.avoidDataTransfer(event.dataTransfer);
    this.setDragStartPosition(event.originalEvent);

  }),

  onDragEnd: Ember.on('dragEnd', function(event){
    Ember.debug("onDragEnd: " + this.get('dragDirection'));
    this.trigger('onDragged', this.get('dragDirection'), this.get('dragDistance'));
  }),

  onDragOver: Ember.on('dragOver', function(event){
    this.setDragOverPosition(event.originalEvent);
    this.trigger('onDragging', this.get('dragDirection'), this.get('dragDistance'));
  }),

  dragDirection: Ember.computed('dragStartX', 'dragOverX', function() {
    return (this.get('dragStartX') > this.get('dragOverX')) ? 'left' : 'right';
  }),

  dragDistance: Ember.computed('dragStartX', 'dragOverX', function() {
    return Math.abs(this.get('dragStartX') - this.get('dragOverX'));
  }),

  avoidDataTransfer(dataTransfer) {
    var image = this.$('.trans-pixel').get(0);
    if( Ember.isPresent(image) ) {
      event.dataTransfer.setDragImage(image, 0, 0);
      event.dataTransfer.setData("text/plain", "");
    }
  },

  setDragStartPosition(event) {
    this.set('dragStartX', event.pageX);
    this.set('dragStartY', event.pageY);
  },

  setDragOverPosition(event) {
    this.set('dragOverX', event.pageX);
    this.set('dragOverY', event.pageY);
  }

});

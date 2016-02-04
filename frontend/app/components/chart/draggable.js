import Ember from 'ember';

export default Ember.Mixin.create( {
  attributeBindings: [ 'draggable' ],
  classNameBindings: ['isDragging:dragging'],

  draggable: true,


  onDragStart: Ember.on('dragStart', function(event) {
    this.set('isDragging', true);
    this.avoidDataTransfer(event.dataTransfer);
    this.setDragPositions(event.originalEvent);

  }),

  onDragEnd: Ember.on('dragEnd', function(event){
    this.set('isDragging', false);
    this.trigger('onDragged');
  }),

  onDragOver: Ember.on('dragOver', function(event){
    this.updateDragPositions(event.originalEvent);
    if( 10 < this.get('dragDistance') &&  this.get('dragDistance') < 20 ) {
      this.trigger('onDragging', this.get('dragDirection'), this.get('dragDistance'));
    }
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

  setDragPositions(event) {
    this.set('dragStartX', event.pageX);
    this.set('dragStartY', event.pageY);
    this.set('dragOverX',  event.pageX);
    this.set('dragOverY',  event.pageY);
  },

  updateDragPositions(event) {
    this.set('dragStartX', this.get('dragOverX'));
    this.set('dragStartY', this.get('dragOverY'));
    this.set('dragOverX', event.pageX);
    this.set('dragOverY', event.pageY);
  }

});

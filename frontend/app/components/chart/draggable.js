/* global moment */
import Ember from 'ember';

export default Ember.Mixin.create( {
  attributeBindings: [ 'draggable' ],
  classNameBindings: ['isDragging:dragging'],

  draggable: true,


  onDragStart: Ember.on('dragStart', function(event) {
    this.set('isDragging', true);
    this.set('lastTriggerAt', moment() );
    this.avoidDataTransfer(event.dataTransfer);
    this.setDragPositions(event.originalEvent);

  }),

  onDragEnd: Ember.on('dragEnd', function(){
    this.set('isDragging', false);
    this.trigger('onDragged');
  }),

  onDragOver: Ember.on('dragOver', function(event){
    this.updateDragPositions(event.originalEvent);

    if( this.isTimeToTrigger() ) {
      this.set('lastTriggerAt', moment() );
      this.trigger('onDragging', this.get('dragDirection'));
    }

  }),

  dragDirection: Ember.computed('dragStartX', 'dragOverX', function() {
    if(Ember.isPresent(this.get('dragStartX')) && Ember.isPresent(this.get('dragOverX'))) {
      if(this.get('dragStartX') > this.get('dragOverX')) {
        return 'left';
      } else if (this.get('dragStartX') < this.get('dragOverX')) {
        return 'right';
      }
    }
  }),

  dragDistance: Ember.computed('dragStartX', 'dragOverX', function() {
    return Math.abs(this.get('dragStartX') - this.get('dragOverX'));
  }),

  isTimeToTrigger() {
    var milliFromLastTrigger = moment() - this.get('lastTriggerAt');
    if( this.get('dragDistance') === 0) {
      return false;
    } else {
      return (milliFromLastTrigger > 100);
    }
  },

  avoidDataTransfer(dataTransfer) {
    var image = this.$('.trans-pixel').get(0);
    if( Ember.isPresent(image) ) {
      dataTransfer.setDragImage(image, 0, 0);
      dataTransfer.setData("text/plain", "");
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

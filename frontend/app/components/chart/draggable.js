import Ember from 'ember';

export default Ember.Mixin.create( {
  attributeBindings: [ 'draggable' ],
  classNameBindings: ['isDragging:dragging'],

  draggable: true,

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

  touchStart(event) {
    this._super(...arguments);
    this.set('isDragging', true);
    this.set('lastTriggerAt', moment() );
    this.setDragPositions(event.originalEvent.touches[0]);
  },

  touchMove(event) {
    this._super(...arguments);
    this.updateDragPositions(event.originalEvent.touches[0]);
    this.triggerIfNeed();
  },

  touchEnd() {
    this._super(...arguments);
    this.set('isDragging', false);
    this.trigger('onDragged');
  },

  dragStart(event) {
    this._super(...arguments);
    this.set('isDragging', true);
    this.set('lastTriggerAt', moment() );
    this.avoidDataTransfer(event.dataTransfer);
    this.setDragPositions(event.originalEvent);

  },

  dragEnd(){
    this._super(...arguments);
    this.set('isDragging', false);
    this.trigger('onDragged');
  },

  dragOver(event){
    this._super(...arguments);
    this.updateDragPositions(event.originalEvent);
    this.triggerIfNeed();
  },

  triggerIfNeed() {
    if( this.isTimeToTrigger() ) {
      this.set('lastTriggerAt', moment() );
      this.trigger('onDragging', this.get('dragDirection'));
    }
  },

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

import Ember from 'ember';

export default Ember.Mixin.create( {
  resizeEndDelay: 200,
  resizing: false,

  onDidInsertElement: Ember.on('didInsertElement', function(){
    this.installHandlers();
  }),

  onWillDestroyElement: Ember.on('willDestroyElement', function(){
    this.removeHandlers();
  }),

  installHandlers() {
    return Ember.$(window).on("resize." + this.elementId, this.handlerManager.bind(this));
  },

  removeHandlers() {
    Ember.$(window).off("resize." + this.elementId, this.handlerManager.bind(this));
  },

  endResize(event) {
    this.set('resizing', false);
    Ember.tryInvoke(this, 'onResizeEnd', [event]);
  },

  handlerManager(event) {
    if( !this.get('resizing') ) {
      this.set('resizing', true);
      Ember.tryInvoke(this, 'onResizeStart', [event]);
      Ember.run.debounce(this, this.get('endResize'), event, this.get('resizeEndDelay'));
    }
  }
});

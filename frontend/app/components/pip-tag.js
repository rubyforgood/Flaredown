import Ember from 'ember';

export default Ember.Component.extend({
  tagName: 'li',

  classNameBindings: ['colorClass'],

  classNames: ['pip-elem basic'],

  colorClass: Ember.computed('isActive', function() {
    if(this.get('isActive')) {
      return `highlight ${this.get('modelBgClass')}`;
    } else {
      return "no-highlight";
    }
  }),

  isActive: Ember.computed('value', 'selected', 'current', function() {
    if(Ember.isPresent(this.get('current'))) {
      return this.get('value') <= this.get('current');
    } else {
      return this.get('value') <= this.get('selected');
    }
  }),

  click() {
    return this.get('onClick')(this.get('value'));
  },

  mouseEnter() {
    return this.get('onMouseEnter')(this.get('value'));
  },

  mouseLeave() {
    return this.get('onMouseLeave')(this.get('value'));
  }

});

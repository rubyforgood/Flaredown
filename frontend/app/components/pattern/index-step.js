import Ember from 'ember';

const {
  set,
  Component
} = Ember;

export default Component.extend({
  classNames: ['flaredown-transparent-box'],

  actions: {
    newPattern() {
      this.sendAction('onCreate');
    },

    edit(pattern){
      this.sendAction('onEdit', pattern);
    }
  }
});

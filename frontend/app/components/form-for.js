import Ember from 'ember';

export default Ember.Component.extend({
  tagName: 'form',
  classNames: 'form',

  submit: function() {
    this.sendAction('onSubmit', this.get('for'));
    return false;
  }

});

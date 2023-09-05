import Ember from 'ember';
import FormForComponent from './form-for';

export default Ember.Component.extend({
  classNames: 'form-field input',
  type: 'text',

  model: Ember.computed.alias('parentView.for'),

  didInsertElement() {
    Ember.run.scheduleOnce('afterRender', () => {
      var parentView = this.get('parentView');
      var elementId = this.get('elementId');
      Ember.assert("FormFieldComponent (element ID: " + elementId + ") must have a parent view in order to yield.", parentView);
      Ember.assert("FormFieldComponent (element ID: " + elementId + ") should be inside a FormForComponent.", FormForComponent.detectInstance(parentView));
    });
  },


  hasError: Ember.computed('model.errors.[]', function() {
    var ref;
    if ((ref = this.get('model.errors')) != null) {
      return ref.has(this.get('for'));
    } else {
      return false;
    }
  }),

  errorClass: Ember.computed('hasError', function() {
    if (this.get('hasError')) {
      return 'error';
    } else {
      return '';
    }
  }),

  errors: Ember.computed('model.errors.[]', function() {
    var errors = this.get('model.errors');
    return errors.errorsFor(this.get('for')).mapBy('message').join(', ');
  })

});

import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['save-status'],

  saveFailed: Ember.computed('record.errors.[]', function() {
    let errors = this.get('record.errors');
    if (Ember.isPresent(errors)) {
      return errors.has('saveFailure');
    } else {
      return false;
    }
  }),

  saveFailureMessage: Ember.computed('record.errors.[]', function() {
    let errors = this.get('record.errors');
    return errors.errorsFor('saveFailure').mapBy('message').join(', ');
  })
});

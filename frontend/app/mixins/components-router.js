import Ember from 'ember';

export default Ember.Mixin.create({

  router: function() {
    return Ember.getOwner(this).lookup('route:application');
  },

});

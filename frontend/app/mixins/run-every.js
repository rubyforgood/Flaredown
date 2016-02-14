import Ember from 'ember';

export default Ember.Mixin.create({

  runEvery(seconds, callback, params) {
    Ember.run.later(this, function() {
      callback(params);
      if (this.get('isDestroyed') || this.get('isDestroying')) {
        return;
      } else {
        this.runEvery(seconds, callback, params);
      }
    }, seconds*1000);
  }

});

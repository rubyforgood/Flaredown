import Ember from 'ember';

const {
  get,
  set,
  computed,
  Component,
  Logger: { debug },
  computed: { alias },
} = Ember;

export default Component.extend({
  checkin: alias('parentView.checkin'),

  relatedObjects: computed('checkin', function() {
    return get(this, 'checkin.' + get(this, 'relationName'));
  }),

  actions: {
    add(obj) {
      get(this, 'checkin').addObj(obj, get(this, 'idsKey'), get(this, 'relationName'));
      this.saveCheckin();
    },

    remove(obj) {
      get(this, 'checkin').removeObj(obj, get(this, 'idsKey'), get(this, 'relationName'));
      this.saveCheckin();
    },
  },

  saveCheckin() {
    if (get(this, 'checkin.hasDirtyAttributes')) {
      Ember.run.next(this, function() {
        get(this, 'checkin')
          .save()
          .then(
            () => {
              debug('Checkin successfully saved');

              set(this, 'checkin.hasDirtyAttributes', false);
            },
            (error) => {
              get(this, 'checkin').handleSaveError(error);
            }
          )
          .then(() => get(this, 'chartsVisibilityService').refresh());
      });
    }
  },
});

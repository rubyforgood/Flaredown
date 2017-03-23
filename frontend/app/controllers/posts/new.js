import Ember from 'ember';

const {
  get,
  Controller,
} = Ember;

export default Controller.extend({
  actions: {
    addTopic() {

    },

    savePost() {
      get(this, 'model').save();
    },

    searchObjects() {

    },
  },
});

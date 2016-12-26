import Ember from 'ember';

export default Ember.Mixin.create({
  // In order do debounce search request the extended objects should implement "performSearch" function
  // with the following signature:
  //
  // performSearch(term, resolve, reject) {
  //   this
  //     .yourSearchActionWhichReturnsPromise(term)
  //     .then(function() { resolve(...arguments); }, reject);
  // }
  //
  // and use "searchObjects(term)" action defined in this mixin
  //
  // also one can redefine "debounceTimeout" in his extended objects if need to

  debounceTimeout: 200,

  searchByTerm(resource, term) {
    return this.customSearch({
      resource: resource,
      query: {
        name: term
      }
    });
  },

  randomSearch(resource) {
    return this.customSearch({
      resource: resource,
      scope: 'random'
    });
  },

  customSearch(params) {
    return this.store.queryRecord('search', params).then((searchRecord) => {
      return searchRecord.get('searchables');
    });
  },

  createRecord(resource, term) {
    return this.store.createRecord(resource, { name: term });
  },

  createAndSave(resource, term) {
    return new Ember.RSVP.Promise((resolve, reject) => {
      this.createRecord(resource, term).save().then(function(saved) {
        resolve(saved);
      }, function() {
        reject(...arguments);
      });
    });
  },

  actions: {
    searchObjects(term) {
      return new Ember.RSVP.Promise((resolve, reject) => {
        Ember.run.debounce(this, this.performSearch, term, resolve, reject, this.get('debounceTimeout'));
      });
    },

    shouldShowCreateOption(term, options) {
      let foundOption = options.find(function(item) {
        return Ember.isEqual(term.toLowerCase(), item.get('name').toLowerCase());
      });
      return !Ember.isPresent(foundOption);
    },
  },
});

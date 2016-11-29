import Ember from 'ember';

export default Ember.Mixin.create({

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
    shouldShowCreateOption(term, options) {
      let foundOption = options.find(function(item) {
        return Ember.isEqual(term.toLowerCase(), item.get('name').toLowerCase());
      });
      return !Ember.isPresent(foundOption);
    }
  }

});

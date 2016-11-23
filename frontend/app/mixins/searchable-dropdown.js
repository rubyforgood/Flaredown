import Ember from 'ember';

export default Ember.Mixin.create({

  searchByTerm(resource, term) {
    let params = {
      resource: resource,
      query: {
        name: term
      }
    };
    return this.store.queryRecord('search', params).then((searchRecord) => {
      return searchRecord.get('searchables');
    });
  }

});

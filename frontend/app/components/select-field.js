import Ember from 'ember';

export default Ember.Component.extend({
  items: [],
  selection: null,
  resource: null,
  defaultQueryParams: null,
  placeholder: 'select item',
  async: true,
  create: false,
  openOnFocus: true,
  multiple: false,

  createItemAction: Ember.computed('create', function() {
    return this.get('create') ? 'createItem' : false;
  }),

  findAll() {
    this.store.findAll(this.get('resource')).then( (items) => {
      this.refreshItems(items);
    });
  },

  findByQuery(params = { }) {
    this.store.queryRecord('search', this.queryParams(params)).then( (items) => {
      this.refreshItems(items.get('searchables'));
    });
  },

  refreshItems(items) {
    this.set('items', items);
    this.selectByName();
    this.autoFocus();
  },

  queryParams(params) {
    var defaults = this.get('defaultQueryParams');
    if (Ember.isPresent(defaults)) {
      if (Ember.isNone(params['query'])) {
        params['query'] = {};
      }
      for (var key in defaults) { params['query'][key] = defaults[key]; }
    }
    return params;
  },

  selectByName() {
    var name = this.get('autoSelectName');
    if (Ember.isPresent(name)) {
      var item = this.get('items').findBy('name', name);
      if (Ember.isPresent(item)) {
        this.set('selection', item);
      }
    }
  },

  autoFocus() {
    if (this.get('setFocus')) {
      this.$('input').focus();
    }
  },

  actions: {
    fetchItems() {
      if(this.get('async')) {
        this.findByQuery({ resource: this.get('resource') });
      } else if(Ember.isEmpty(this.get('items')) ) {
        this.findAll();
      }
    },

    selectItem(item) {
      Ember.tryInvoke(this, 'onSelect', [item]);
    },

    createItem(value) {
      var item = this.store.createRecord(this.get('resource'), { name: value });
      this.set('selection', item);
      Ember.tryInvoke(this, 'onSelect', [item]);
    },

    updateFilter(value) {
      if( this.get('async') && value.length >= 1 ) {
        this.findByQuery({ resource: this.get('resource'), query: { name: value } });
      }
    }

  }
});

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

  findByQuery(params = { }, autoAddSelection=false) {
    this.store.queryRecord('search', this.queryParams(params)).then( (items) => {
      this.refreshItems(items.get('searchables'), autoAddSelection);
    });
  },

  refreshItems(items, autoAddSelection=false) {
    this.set('items', items);
    let selectedItem = this.get('selection');
    if (autoAddSelection && Ember.isPresent(selectedItem)) {
      let foundItem = items.toArray().findBy('name', selectedItem.get('name'));
      if (!Ember.isPresent(foundItem)) {
        items.addObject(selectedItem);
      }
    }
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

  fetchItemsOnInit: true,

  actions: {
    fetchItems() {
      if (this.get('fetchItemsOnInit')) {
        if(this.get('async')) {
          this.findByQuery({ resource: this.get('resource') }, true);
        } else if(Ember.isEmpty(this.get('items')) ) {
          this.findAll();
        }
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

import Ember from 'ember';
import SearchableDropdown from 'flaredown/mixins/searchable-dropdown';
import NavbarSearchable from 'flaredown/mixins/navbar-searchable';

const { set, get, Controller } = Ember;

export default Controller.extend(SearchableDropdown, NavbarSearchable,{
  isLoading: false,

  actions: {
    updateEmail(){
      set(this, 'isLoading', true);

      get(this, 'session.actualUser')
        .save()
        .finally(() => set(this, 'isLoading', false));
    }
  }
});

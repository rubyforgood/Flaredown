import Ember from 'ember';
import SearchableDropdown from 'flaredown/mixins/searchable-dropdown';
import NavbarSearchable from 'flaredown/mixins/navbar-searchable';

export default Ember.Controller.extend(SearchableDropdown, NavbarSearchable,{
});

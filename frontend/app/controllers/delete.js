import Ember from 'ember';
import SearchableDropdown from 'flaredown/mixins/searchable-dropdown';
import NavbarSearchable from 'flaredown/mixins/navbar-searchable';

const {
  get,
  inject: {
    service,
  },
} = Ember;

export default Ember.Controller.extend(SearchableDropdown, NavbarSearchable,{
  ajax: service(),
  session: service(),

  deleteReason: '',

  actions: {
    deleteAccount() {
      const deleteReason = get(this, 'deleteReason');
      const ajax = get(this, 'ajax');
      const email = get(this, 'session.currentUser.email');
      const session = get(this, 'session');

      ajax.request(
        '/registrations/destroy',
        {
          method: 'PUT',
          dataType: 'json',
          data: { delete_reason: deleteReason, email }
        }).then(() => session.invalidate());
    }
  }
});

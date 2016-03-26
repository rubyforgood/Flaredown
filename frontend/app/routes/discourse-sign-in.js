import Ember from 'ember';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';

export default Ember.Route.extend(AuthenticatedRouteMixin, {
  ajax: Ember.inject.service(),

  beforeModel(transition) {
     var promise = this.get('ajax').request('/api/discourse', {
      headers: {
        "Authorization": `Token token="${this.get('session.token')}", email="${this.get('session.email')}"`
      },
      method: 'POST',
      data: {
        sso: transition.queryParams.sso,
        sig: transition.queryParams.sig
      }
    });

    promise.then( (payload) => {
      window.location = payload.url;
    });

    return promise;
  }

});

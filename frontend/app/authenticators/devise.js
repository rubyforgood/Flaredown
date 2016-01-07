import Devise from 'ember-simple-auth/authenticators/devise';

export default Devise.extend({
  serverTokenEndpoint: '/api/sessions',
});

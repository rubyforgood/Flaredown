import CookieStore from 'ember-simple-auth/session-stores/cookie';

export default CookieStore.extend({
  cookieExpirationTime: 32000000,
});

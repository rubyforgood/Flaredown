import Ember from 'ember';
import FacebookConnect from 'torii/providers/facebook-connect';

var fbPromise;

function fbLoad(settings){
  if (fbPromise) { return fbPromise; }
  var original = window.fbAsyncInit;
  var locale = settings.locale;
  delete settings.locale;
  fbPromise = new Ember.RSVP.Promise(function(resolve, reject){
    window.fbAsyncInit = function(){
      FB.init(settings);
      Ember.run(null, resolve);
    };
    $.getScript('//connect.facebook.net/' + locale + '/sdk.js');
  }).then(function(){
    window.fbAsyncInit = original;
    if (window.fbAsyncInit) {
      window.fbAsyncInit.hasRun = true;
      window.fbAsyncInit();
    }
  });

  return fbPromise;
}

export default FacebookConnect.extend({
  session: Ember.inject.service('session'),

  name:  'facebook',
  appId: Ember.computed.alias('session.extraSession.facebookAppId'),

  setExtraSession: Ember.observer('session.extraSession', function() {
    fbLoad( this.settings() );
  }),

});



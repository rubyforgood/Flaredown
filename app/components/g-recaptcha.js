/**
 * This file has been copied from ember-g-recaptcha and altered to fix a bug as
 * described in https://github.com/algonauti/ember-g-recaptcha/issues/12
 *
 * Once we upgrade this app to Ember 3+ we can remove this file and update the
 * dependency on ember-g-recaptcha to at least 0.9.0 which fixes this race
 * condition.
 */

import Ember from 'ember';
import Configuration from '../configuration';

export default Ember.Component.extend({

  classNames: ['g-recaptcha'],

  sitekey: Configuration.siteKey,

  tabindex: Ember.computed.alias('tabIndex'),

  renderReCaptcha() {
    // this is the line that was causing a race condition
    if (Ember.isNone(window.grecaptcha) || Ember.isNone(window.grecaptcha.render)) {
      Ember.run.later(() => {
        this.renderReCaptcha();
      }, 500);
    } else {
      let container = this.$()[0];
      let properties = this.getProperties(
        'sitekey',
        'theme',
        'type',
        'size',
        'tabindex'
      );
      let parameters = Ember.merge(properties, {
        callback: this.get('successCallback').bind(this),
        'expired-callback': this.get('expiredCallback').bind(this)
      });
      let widgetId = window.grecaptcha.render(container, parameters);
      this.set('widgetId', widgetId);
      this.set('ref', this);
    }
  },

  resetReCaptcha() {
    if (Ember.isPresent(this.get('widgetId'))) {
      window.grecaptcha.reset(this.get('widgetId'));
    }
  },

  successCallback(reCaptchaResponse) {
    let action = this.get('onSuccess');
    if (Ember.isPresent(action)) {
      action(reCaptchaResponse);
    }
  },

  expiredCallback() {
    let action = this.get('onExpired');
    if (Ember.isPresent(action)) {
      action();
    } else {
      this.resetReCaptcha();
    }
  },


  // Lifecycle Hooks

  didInsertElement() {
    this._super(...arguments);
    Ember.run.next(() => {
      this.renderReCaptcha();
    });
  }

});
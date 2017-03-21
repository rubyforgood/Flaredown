import Ember from 'ember';

const {
  computed,
  Component,
} = Ember;

export default Component.extend({
  init() {
    this._super(...arguments);

    Ember.run.scheduleOnce('afterRender', () => {
      this.$().append([
        '<script>',
        '!function(d,s,id){',
        'var js,ajs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){',
        'js=d.createElement(s);js.id=id;',
        'js.src="https://assets.tumblr.com/share-button.js";ajs.parentNode.insertBefore(js,ajs);',
        '}}(document, "script", "tumblr-js");',
        '</script>'
      ].join("\n"));
    });
  },

  currentUrl: computed(function() {
    return window.location.href;
  }),
});

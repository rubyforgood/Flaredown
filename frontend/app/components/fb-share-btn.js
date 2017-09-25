import Ember from 'ember';
import layout from 'ember-social-share/templates/components/fb-share-button';

const {
  get,
  computed,
  Component
} = Ember;

export default Component.extend({
  layout,
  shareURL: 'https://facebook.com/sharer.php',
  tagName: 'a',
  classNames: ['fb-share-button', 'share-button'],
  classNameBindings: ['adaptive:adaptive-button'],
  attributeBindings: ['fbUrl:href', 'target'],
  adaptive: true,
  target: '_blank',

  fbUrl: computed('shareURL', function() {
    let url = get(this, 'shareURL');
    url += '?display=popup';
    url += '&u=' + encodeURIComponent(this.getCurrentUrl());
    url += this.get('title') ? '&title=' + this.get('title') : '';
    url += this.get('image') ? '&picture=' + this.get('image') : '';
    url += this.get('text') ? '&description=' + this.get('text') : '';

    return url;
  }),

  getCurrentUrl() {
    return get(this, 'url') ? get(this, 'url') : document.location.href;
  },
});

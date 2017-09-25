import Ember from 'ember';
import layout from 'ember-social-share/templates/components/twitter-share-button';

const {
  get,
  computed,
  Component
} = Ember;

export default Component.extend({
  layout,
  tagName: 'a',
  shareURL: 'https://twitter.com/intent/tweet',
  classNames: ['twitter-share-button', 'share-button'],
  hashtags: '',
  classNameBindings: ['adaptive:adaptive-button'],
  attributeBindings: ['twitterUrl:href', 'target'],
  adaptive: true,
  target: '_blank',

  twitterUrl: computed('shareURL', function() {
    let url = get(this, 'shareURL');
    url += '?text=' + this.get('title');
    url += '&url=' + encodeURIComponent(this.getCurrentUrl());
    url += this.get('hashtags') ? '&hashtags=' + this.get('hashtags') : '';
    url += this.get('via') ? '&via=' + this.get('via') : '';

    return url;
  }),

  getCurrentUrl() {
    return get(this, 'url') ? get(this, 'url') : document.location.href;
  },
});

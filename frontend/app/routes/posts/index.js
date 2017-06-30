import Ember from 'ember';
import HistoryTrackable from 'flaredown/mixins/history-trackable';
import ToggleHeaderLogo from 'flaredown/mixins/toggle-header-logo';
import AddMetaTags from 'flaredown/mixins/add-meta-tags';

const {
  set,
  get,
  Route,
  RSVP: {
    hash,
  },
} = Ember;

export default Route.extend(HistoryTrackable, ToggleHeaderLogo, AddMetaTags, {
  queryParams: {
    following: { refreshModel: true },
    query: { refreshModel: true }
  },

  model(params) {
    set(this, 'query', params.query);
    const currentUser = get(this, 'session.currentUser');

    return hash({
      posts: get(this, 'store').query('post', params).then(q => q.toArray()),
      topicFollowing: currentUser ? currentUser.then(user => get(user, 'topicFollowing')) : [],
    });
  },

  setHeadTags: function() {
    const currentUrl = get(this, 'currentUrl');

    const headTags = [
      { type: 'meta',
        tagId: 'title',
        attrs: {
          property: 'og:title',
          content: 'Discussion',
        },
      },
      { type: 'meta',
        tagId: 'description',
        attrs: {
          property: 'og:description',
          content: 'Discussion',
        },
      },
      { type: 'meta',
        tagId: 'url',
        attrs: {
          property: 'og:url',
          content: currentUrl,
        },
      },

      //Twitter meta tags
      { type: 'meta',
        tagId: 'card',
        attrs: {
          name: 'twitter:card',
          content: 'summary',
        },
      },
      {
        type: 'meta',
        tagId: 'googleDesc',
        attrs: {
          name: 'description',
          content: 'Discussion',
        },
      },
    ];

    set(this, 'headTags', headTags);
  },
});

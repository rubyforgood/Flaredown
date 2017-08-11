import Ember from 'ember';
import HistoryTrackable from 'flaredown/mixins/history-trackable';
import ToggleHeaderLogo from 'flaredown/mixins/toggle-header-logo';
import AddMetaTags from 'flaredown/mixins/add-meta-tags';

const {
  get,
  set,
  inject: {
    service,
  },
  Route,
  getProperties,
  RSVP: {
    hash,
  },
} = Ember;

const availableTypes = ['tag', 'symptom', 'condition', 'treatment'];

export default Route.extend(HistoryTrackable, ToggleHeaderLogo, AddMetaTags, {
  session: service(),
  fastboot: service(),

  model(params) {
    const { type } = params;

    if (!availableTypes.includes(type)) {
      return this.transitionTo('posts');
    }

    const store = get(this, 'store');
    const currentUser = get(this, 'session.currentUser');
    const topicFollowing = currentUser ? currentUser.then(user => get(user, 'topicFollowing')) : [];

    if (get(this, 'fastboot.isFastBoot') || get(this, 'fastboot.hasPeeked')){
      return this.makeRequest(store, params, topicFollowing);
    } else {
      set(this, 'fastboot.hasPeeked', true);

      return this.peekData(store, params, topicFollowing);
    }
  },

  makeRequest(store, params, topicFollowing) {
    const { id, type } = params;

    return hash({
      id,
      type,
      page: 1,
      posts: store.query('post', { id, type }).then(q => q.toArray()),
      topic: store.findRecord(type, id),
      topicFollowing: topicFollowing
    });
  },

  peekData(store, params, topicFollowing) {
    const { id, type } = params;

    const posts = store.peekAll('post').toArray();
    const topic = store.peekRecord(type, id);

    return hash({
      id,
      type,
      page: 1,
      posts: posts,
      topic: topic,
      topicFollowing: topicFollowing
    });
  },

  historyEntry(model) {
    const { id, type } = getProperties(model, 'id', 'type');

    return this._super(...arguments).pushObjects([type, id]);
  },

  setHeadTags: function(model) {
    const currentUrl = get(this, 'currentUrl');

    const headTags = [
      { type: 'meta',
        tagId: 'title',
        attrs: {
          property: 'og:title',
          content: 'Topic',
        },
      },
      { type: 'meta',
        tagId: 'description',
        attrs: {
          property: 'og:description',
          content: get(model, 'topic.name'),
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
          content: get(model, 'topic.name'),
        },
      },
    ];

    set(this, 'headTags', headTags);
  },

});

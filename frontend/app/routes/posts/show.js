import Ember from 'ember';
import HistoryTrackable from 'flaredown/mixins/history-trackable';
import ToggleHeaderLogo from 'flaredown/mixins/toggle-header-logo';
import AddMetaTags from 'flaredown/mixins/add-meta-tags';
import UpdateNotifications from 'flaredown/mixins/update-notifications';

const {
  get,
  set,
  run: {
    schedule,
  },
  Route,
} = Ember;

export default Route.extend(HistoryTrackable, ToggleHeaderLogo, AddMetaTags, UpdateNotifications, {
  updateNotifications: true,

  afterModel() {
    const currentModel = this.modelFor(this.routeName);

    schedule('afterRender', this, this.updatePostNotifications, currentModel);
  },

  resetController(controller, isExiting) {
    if (isExiting) {
      set(controller, 'anchor', null);
    }
  },
  model(params) {
    return get(this, 'store').find('post', params.id);
  },

  setupController(controller, model) {
    this._super(controller, model);

    set(controller, 'newComment', get(this, 'store').createRecord('comment'));
  },

  historyEntry(model) {
    let entry = this._super(...arguments);

    entry.pushObject([get(model, 'id')]);

    return entry;
  },

  setHeadTags: function(model) {
    const currentUrl = get(this, 'currentUrl');

    const headTags = [
      { type: 'meta',
        tagId: 'title',
        attrs: {
          property: 'og:title',
          content: model.get('title'),
        },
      },
      { type: 'meta',
        tagId: 'description',
        attrs: {
          property: 'og:description',
          content: model.get('body'),
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
          content: model.get('body'),
        },
      },
    ];

    set(this, 'headTags', headTags);
  },
});

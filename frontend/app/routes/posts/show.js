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
  computed,
  inject: {
    service,
  },
  Route,
} = Ember;

export default Route.extend(HistoryTrackable, ToggleHeaderLogo, AddMetaTags, UpdateNotifications, {
  fastboot: service(),

  updateNotifications: true,
  modelName: 'post',

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
    let shoebox = get(this, 'fastboot.shoebox');
    let shoeboxStore = shoebox.retrieve('posts-show');

    if (get(this, 'fastboot.isFastBoot')) {
      return get(this, 'store').findRecord('post', params.id).then(post => {
        if (!shoeboxStore) {
          shoeboxStore = {};
        }

        shoeboxStore[post.id] = post.toJSON({'includeId': true});
        shoebox.put('posts-show', shoeboxStore);
        return post;
      });
    } else {
      return this.getEmberModel('post', shoeboxStore[params.id]);
    }
  },

  getEmberModel(modelName, payload){
    if (payload) {
      const store = get(this, 'store');
      const data = {[modelName]: payload };

      store.pushPayload(modelName, data);
      return store.peekRecord(modelName, payload.id);
    }
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
          content: get(model, 'title'),
        },
      },
      { type: 'meta',
        tagId: 'description',
        attrs: {
          property: 'og:description',
          content: get(model, 'body'),
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
          content: get(model, 'body'),
        },
      },
    ];

    set(this, 'headTags', headTags);
  },
});

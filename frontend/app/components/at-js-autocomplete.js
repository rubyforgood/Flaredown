import Ember from 'ember';

const {
  get,
  inject: {
    service,
  },
  TextArea
} = Ember;

export default TextArea.extend({
  ajax: service(),
  placeholder: 'Leave a comment...',

  classNames: ['atwho-inputor'],

  didInsertElement() {
    this._super(...arguments);

    const ajax = get(this, 'ajax');
    const postId = get(this, 'postId');

    this.$().atwho({
      at: "@",
      insertTpl: "@${slug_name}",
      displayTpl: '<li>${screen_name}</li>',
      callbacks: {
        sorter(query, data) {
          return data;
        },
        remoteFilter(query, callback) {
          ajax.request('/profiles', { data: { query: query, post_id: postId} }).then(({ profiles }) => callback(profiles));
        }
      }
    });
  }
});

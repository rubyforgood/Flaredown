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

    ajax.request('/profiles', { data: { post_id: postId } }).then(({ profiles }) => {
      let userList = profiles.map(function(item) {
        return { screen_name: item.screen_name, slug_name: item.slug_name };
      });

      this.$().atwho({
        at: "@",
        insertTpl: "@${slug_name}",
        displayTpl: '<li>${screen_name}</li>',
        searchKey: "screen_name",
        data: userList,
      });
    });
  }
});

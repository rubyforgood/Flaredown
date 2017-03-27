export default {
  name: 'selectableData',

  initialize: function initialize(application) {
    application.inject('controller:posts/new', 'selectableData', 'service:selectable-data');
  }
};

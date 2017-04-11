import Ember from 'ember';

const {
  get,
  Mixin,
  computed,
  String: {
    htmlSafe,
  },
} = Ember;

export default Mixin.create({
  bodyWithBr: computed('body', function() {
    return htmlSafe((get(this, 'body') || '').replace(/\n/g, "<br>"));
  }),
});

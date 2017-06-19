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
    const phrase = "@[A-Z][A-z0-9]+\\b";
    const changedBody = (get(this, 'body') || []).replace(new RegExp(phrase, 'g'), (item) => { return `<b>${item}</b>`; });

    return htmlSafe((changedBody || '').replace(/\n/g, "<br>") );
  }),
});

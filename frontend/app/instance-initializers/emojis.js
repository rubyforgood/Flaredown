export function initialize(appInstance) {
  appInstance.inject('component:emoji-menu', 'emojis', 'service:emojis');
  appInstance.inject('component:emoji-reaction', 'emojis', 'service:emojis');
}

export default {
  name: 'emojis',
  initialize
};

export function initialize(appInstance) {
  appInstance.inject('component:emoji-menu', 'emojis', 'service:emojis');
}

export default {
  name: 'emojis',
  initialize
};

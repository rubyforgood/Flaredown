export function initialize() {
  window.DragDropPolyfill.Initialize({
    dragImageOffset: { x: -100, y: 0 }
  });
}

export default {
  name: 'drag-drop-polyfill',
  initialize
};

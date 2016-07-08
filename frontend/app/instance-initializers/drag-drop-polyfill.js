export function initialize() {
  window.DragDropPolyfill.Initialize({
    dragImageOffset: { x: 20, y: 0 }
  });
}

export default {
  name: 'drag-drop-polyfill',
  initialize
};

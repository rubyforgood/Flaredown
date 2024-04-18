import {polyfill} from "mobile-drag-drop";
import {scrollBehaviourDragImageTranslateOverride} from "mobile-drag-drop/scroll-behaviour";

export function initialize() {
  if (typeof FastBoot === 'undefined') {
    polyfill({
      dragImageTranslateOverride: scrollBehaviourDragImageTranslateOverride,
      dragImageOffset: { x: 20, y: 0 }
    });
  }
}

export default {
  name: 'drag-drop-polyfill',
  initialize
};

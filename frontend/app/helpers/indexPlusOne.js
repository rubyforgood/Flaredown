import { helper } from "@ember/component/helper";

export function indexPlusOne(a) {
  return parseInt(a) + 1;
}

export default helper(indexPlusOne);

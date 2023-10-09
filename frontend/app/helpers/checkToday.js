import { helper } from '@ember/component/helper';
import moment from 'moment';

export function checkToday(params) {
  let [date, displayText] = params;
  const checkdate = moment(new Date()).format("YYYY-MM-DD") == date ? displayText : null
  return checkdate
}

export default helper(checkToday);

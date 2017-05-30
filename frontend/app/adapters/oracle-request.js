import ApplicationAdapter from 'flaredown/adapters/application';

export default ApplicationAdapter.extend({
  ajaxOptions() {
    let hash = this._super(...arguments);

    if (localStorage.oracleToken) {
      let { beforeSend } = hash;

      hash.beforeSend = (xhr) => {
        xhr.setRequestHeader('X-Oracle-Token', localStorage.oracleToken);

        if (beforeSend) {
          beforeSend(xhr);
        }
      };
    }

    return hash;
  },
});


/*jshint node:true*/
module.exports = {
  name: 'full-story',

  isDevelopingAddon: function() {
    return true;
  },

  contentFor: function(type, config) {
    var addonConfig = config['full-story'];
    if (type === 'head-footer' && addonConfig['enabled']) {
      var org = addonConfig['org'];
      return [
        "<script>",
        "window['_fs_debug'] = false;",
        "window['_fs_host'] = 'www.fullstory.com';",
        "window['_fs_org'] = '" + org + "';",
        "window['_fs_namespace'] = 'FS';",
        "(function(m,n,e,t,l,o,g,y){",
        "  if (e in m && m.console && m.console.log) { m.console.log('FullStory namespace conflict. Please set window[\"_fs_namespace\"].'); return;}",
        "  g=m[e]=function(a,b){g.q?g.q.push([a,b]):g._api(a,b);};g.q=[];",
        "  o=n.createElement(t);o.async=1;o.src='https://'+_fs_host+'/s/fs.js';",
        "  y=n.getElementsByTagName(t)[0];y.parentNode.insertBefore(o,y);",
        "  g.identify=function(i,v){g(l,{uid:i});if(v)g(l,v)};g.setUserVars=function(v){g(l,v)};",
        "  g.identifyAccount=function(i,v){o='account';v=v||{};v.acctId=i;g(o,v)};",
        "  g.clearUserCookie=function(d,i){d=n.domain;while(1){n.cookie='fs_uid=;domain='+d+",
        "  ';path=/;expires='+new Date(0);i=d.indexOf('.');if(i<0)break;d=d.slice(i+1)}}",
        "})(window,document,window['_fs_namespace'],'script','user');",
        "</script>"
      ].join('\n');
    }
  }

};

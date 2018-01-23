({
    url_param: function(){
        return window.location.search.substring(1).split('&').map(function(e){
            return e.split('=');
        }).reduce(function(cur, nex){
            cur[nex[0]] = decodeURIComponent(nex[1]);
            return cur;
        }, {})
    }
})
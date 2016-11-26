vcl 4.0;

backend default {
  .host = "127.0.0.1";
  .port = "3000";
}

backend devicedetect {
  .host = "127.0.0.1";
  .port = "5000";
}

sub vcl_recv {
  # first call headers
  if (req.restarts == 0) {
    set req.backend_hint = devicedetect;
    # store the original url in a HTTP-Header
    set req.http.x-ua-device-orig-url = req.url;
    set req.url = "/device/";
    return(hash);
  }
}

sub vcl_hash {
  hash_data(req.url);

  if (req.http.User-Agent && req.url == "/device/") {
    hash_data(req.http.User-Agent);
  }

  return (lookup);
}

sub vcl_deliver {
  # second call page
  if (req.http.x-ua-device-orig-url) {
    # now call again with the real url without headers
    set req.url = req.http.x-ua-device-orig-url;
    set req.backend_hint = default;
    unset req.http.x-ua-device-orig-url;

    if (resp.http.x-ua-device) {
      set req.http.x-ua-device = resp.http.x-ua-device;
    }

    if (resp.status >= 300 && resp.status < 400 && resp.http.Location ) {
      return (deliver);
    }

    return(restart);
  }

  # pass along the x-ua-device header as response - uncomment if you do not want to pass on this resp header
  if (req.http.x-ua-device) {
    set resp.http.x-ua-device = req.http.x-ua-device;
  }

  if (resp.http.Vary !~ "User-Agent" ){
    set resp.http.Vary=regsub(regsub(resp.http.Vary, "^", "User-Agent, "), "[ ,]*$" , "" );
  }
}

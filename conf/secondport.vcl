vcl 4.0;

import std;

backend default {
  .host = "127.0.0.1";
  .port = "3000";
}

sub vcl_recv {
  if (std.port(server.ip) == 8001) {
    set req.http.port = 3000;
    set req.backend_hint = default;
    if (req.method != "GET" && req.method != "HEAD") {
      return (pass);
    } else {
      return (hash);
    }
  }
}

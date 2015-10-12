
backend default {
  .host = "127.0.0.1";
  .port = "3000";
}

sub vcl_recv {
  if (server.port == 8001) {
    set req.http.port = 3000;
    set req.backend = default;
    if (req.request != "GET" && req.request != "HEAD") {
      return (pass);
    } else {
      return (lookup);
    }
  }
}

backend default {
  .host = "127.0.0.1";
  .port = "3000";
}

backend other {
  .host = "127.0.0.1";
  .port = "4000";
}

sub vcl_recv {
  if (req.url ~ "^/other") {
    set req.backend = other;
    if (req.request != "GET" && req.request != "HEAD") {
      return (pass);
    } else {
      return (lookup);
    }
  }
}


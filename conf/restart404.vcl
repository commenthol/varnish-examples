vcl 4.0;

backend default {
  .host = "localhost";
  .port = "3000";
}

backend other {
  .host = "localhost";
  .port = "4000";
}

sub vcl_recv {
  if (req.restarts == 0) {
    set req.backend_hint = default;
  } elsif (req.restarts == 1) {
    // change to the other backend
    set req.backend_hint = other;
    // as well as the URL
    set req.url = regsub(req.url, "/404/", "/other");
  }
}

sub vcl_deliver {
  if (resp.status == 404 && req.url ~ "/404/") {
    return (restart);
  }
}

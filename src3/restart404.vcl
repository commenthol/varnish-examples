
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
    set req.backend = default;
  } elsif (req.restarts == 1) {
    // change to the other backend
    set req.backend = other;
    // as well as the URL
    set req.url = regsub(req.url, "/404/", "/other");
  }
}

sub vcl_fetch {
  if (beresp.status == 404 && req.url ~ "/404/") {
    return (restart);
  }
}

vcl 4.0;

backend default {
  .host = "127.0.0.1";
  .port = "3000";
}

sub vcl_backend_response {
  # do not cache any redirects
  if (beresp.status >= 300 && beresp.status < 400 && beresp.http.Location ) {
    set beresp.uncacheable = true;
    return (deliver);
  }
}

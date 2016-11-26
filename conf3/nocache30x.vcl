
backend default {
  .host = "127.0.0.1";
  .port = "3000";
}

sub vcl_fetch {
  # do not cache any redirects
  if (beresp.status >= 300 && beresp.status < 400 && beresp.http.Location ) {
    return (hit_for_pass);
  }
}

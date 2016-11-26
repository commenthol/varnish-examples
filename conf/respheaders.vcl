vcl 4.0;

backend default {
  .host = "127.0.0.1";
  .port = "3000";
}

sub vcl_deliver {
  unset resp.http.X-Varnish;
  unset resp.http.Via;
}

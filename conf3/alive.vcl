
backend default {
  .host = "127.0.0.1";
  .port = "3000";
}

sub error_700 {
  if (obj.status == 700) {
    set obj.status = 200;
    set obj.http.Content-Type = "text/plain; charset=utf-8";
    synthetic {"alive
"};
  }
}

sub vcl_recv {
  if (req.url == "/alive") {
    error 700 "OK";   # see vcl_error, where the status code is changed to 200
  }
}

sub vcl_error {
  call error_700;
  return (deliver);
}
vcl 4.0;

backend default {
  .host = "127.0.0.1";
  .port = "3000";
}

sub vcl_recv {
  if (req.url == "/alive") {
    return (synth(700, "Response"));
  }
}

sub vcl_synth {
  if (resp.status == 700) {
    set resp.status = 200;
    set resp.http.Content-Type = "text/plain; charset=utf-8";
    synthetic ("alive");
    return (deliver);
  }
}

backend default {
  .host = "127.0.0.1";
  .port = "3000";
}

sub cookie_recv {
  # remove all spaces before `;` and add one `;` at the beginning.
  set req.http.Cookie = ";" + req.http.Cookie;
  set req.http.Cookie = regsuball(req.http.Cookie, "; +", ";");

  # white-list cookies - cookies to keep get an whitespace before the cookie-name
  set req.http.Cookie = regsuball(req.http.Cookie, ";(pass)=", "; \1=");

  # delete all non-marked cookies
  set req.http.Cookie = regsuball(req.http.Cookie, ";[^ ][^;]*", "");
  set req.http.Cookie = regsuball(req.http.Cookie, "^[; ]+|[; ]+$", "");

  # unset cookie header in case that all no white listed cookie was present
  if (req.http.Cookie == "") {
    unset req.http.Cookie;
  }
}

sub vcl_recv {
  if (req.http.Cookie) {
    call cookie_recv;
  }
}

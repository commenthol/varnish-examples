'use strict'

var http = require('http')
var url = require('url')

/**
 * starts a HTTP Server
 */
function startServer (port) {
  http.createServer(function (req, res) {
    var status
    var query = url.parse(req.url, true).query || {}

    console.log(req.url, req.headers, query)
    if (req.headers['x-ua-device']) {
      res.setHeader('Vary', 'x-ua-device')
    }

    if (/\/\d{3}/.test(req.url)) {
      status = req.url.replace(/\/(\d{3})/, '$1')
      status = parseInt(status, 10)
      switch (status) {
        case 301:
        case 302:
        case 303: {
          res.statusCode = status
          res.setHeader('Location', (query.location || '/'))
          break
        }
        case 400:
        case 401:
        case 402:
        case 403:
        case 404: {
          res.statusCode = status
          break
        }
        default: {
          res.statusCode = 500
          break
        }
      }
      res.end()
      return
    }

    if (req.headers.cookie) {
      res.write('cookie: ' + req.headers.cookie + '\n')
    }
    res.end(port + ':' + req.url + ' ' + req.method + ' ' + req.headers['x-ua-device'] + '\n')
  }).listen(port)
}

startServer(3000)
startServer(4000)

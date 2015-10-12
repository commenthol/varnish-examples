'use strict'

// automatically start the backend
require('./backend.js')

var http = require('http')

/**
 * simple device detection
 * @param {String} userAgent
 */
function detect (userAgent) {
  if (/\bWindows Phone\b/i.test(userAgent)) {
    return 'mobile'
  } else if (/\biPad\b/i.test(userAgent)) {
    return 'tablet'
  } else if (/\b(iPhone|iPod)\b/i.test(userAgent)) {
    return 'mobile'
  } else if (/\bAndroid 3/i.test(userAgent)) {
    return 'tablet'
  } else if (/\bAndroid.*(?:Mobile|Mini)\b/i.test(userAgent)) {
    return 'mobile'
  } else if (/\b(Android)\b/i.test(userAgent)) {
    return 'tablet'
  } else {
    return 'other'
  }
}

/**
 *
 */
function startDeviceDetect (port) {
  http.createServer(function (req, res) {
    console.log('detect', req.url, req.headers)
    res.setHeader('x-ua-device', detect(req.headers['user-agent']))
    res.end()
  }).listen(port)
}

startDeviceDetect(5000)

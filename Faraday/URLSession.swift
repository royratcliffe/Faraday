// Faraday URLSession.swift
//
// Copyright © 2015, 2016, Roy Ratcliffe, Pioneering Software, United Kingdom
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the “Software”), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED “AS IS,” WITHOUT WARRANTY OF ANY KIND, EITHER
// EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO
// EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
// OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.
//
//------------------------------------------------------------------------------

import Foundation

public class URLSession: Adapter {

  public lazy var configuration: NSURLSessionConfiguration = {
    NSURLSessionConfiguration.defaultSessionConfiguration()
  }()

  public lazy var session: NSURLSession = {
    NSURLSession(configuration: self.configuration)
  }()

  func performRequest(env: Env) {
    guard let request = env.request else {
      return
    }
    guard let URL = request.URL else {
      return
    }
    let URLRequest = NSMutableURLRequest(URL: URL)
    guard let method = request.method else {
      return
    }
    URLRequest.HTTPMethod = method
    URLRequest.allHTTPHeaderFields = env.request?.headers.allHeaderFields
    let handler = { (body: NSData?, URLResponse: NSURLResponse?, error: NSError?) in
      guard let HTTPURLResponse = URLResponse as? NSHTTPURLResponse else {
        return
      }
      let status = HTTPURLResponse.statusCode
      var headers = Headers()
      for (key, value) in HTTPURLResponse.allHeaderFields {
        headers[String(key)] = String(value)
      }
      self.saveResponse(env, status: status, body: body, headers: headers)
    }
    var task: NSURLSessionDataTask
    if let body = request.body as? NSData {
      task = session.uploadTaskWithRequest(URLRequest, fromData: body, completionHandler: handler)
    }
    else {
      task = session.dataTaskWithRequest(URLRequest, completionHandler: handler)
    }
    task.resume()
  }

  public override func call(env: Env) -> Response {
    performRequest(env)
    return app(env)
  }

  /// Sets up a middleware adapter that uses NSURLSession for running requests
  /// and handling responses.
  ///
  /// The handler lets you set up a session configuration and a session. These
  /// override the lazy defaults used by the URL session middleware. You can use
  /// the session reference to retain a session with a delegate: the handler
  /// retains the sessions strongly; the session strongly retains its
  /// delegate. Useful for SSL handshake delegates.
  public class Handler: RackHandler {

    public var configuration: NSURLSessionConfiguration?

    public var session: NSURLSession?

    public init() {}

    public func build(app: App) -> Middleware {
      let middleware = URLSession(app: app)
      if let configuration = configuration {
        middleware.configuration = configuration
      }
      if let session = session {
        middleware.session = session
      }
      return middleware
    }

  }

}

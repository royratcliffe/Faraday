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

  /// Performs a request.
  /// - parameter env: Rack environment under construction.
  /// - returns: New running URL-session data task set up for either uploading
  ///   or downloading data depending on the environment's request body. Presence
  ///   of a body translates to upload, absence to download. Returns without a
  ///   task if the environment contains no request, or the request has no URL or
  ///   no method.
  func performRequest(env: Env) -> NSURLSessionDataTask? {
    guard let request = env.request else {
      return nil
    }
    guard let URL = request.URL else {
      return nil
    }
    let URLRequest = NSMutableURLRequest(URL: URL)
    guard let method = request.method else {
      return nil
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
    } else {
      task = session.dataTaskWithRequest(URLRequest, completionHandler: handler)
    }
    task.resume()
    return task
  }

  /// Performs a request and sets up cancellation.
  /// - parameter env: New Rack environment containing new request.
  /// - returns: New response object attached to the Rack environment. The
  ///   response knows how to cancel the request-response cycle in-flight, if
  ///   necessary.
  public override func call(env: Env) -> Response {
    let task = performRequest(env)
    let response = app(env)
    response.cancelBlock = { [weak task] in
      task?.cancel()
    }
    return response
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

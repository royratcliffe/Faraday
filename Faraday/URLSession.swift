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

  var session: NSURLSession!

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
    var task: NSURLSessionDataTask
    if let body = request.body as? NSData {
      task = session.uploadTaskWithRequest(URLRequest, fromData: body)
    } else {
      task = session.dataTaskWithRequest(URLRequest)
    }
    task.env = env
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
  public class Handler: NSObject, RackHandler, NSURLSessionDataDelegate {

    public lazy var configuration: NSURLSessionConfiguration = {
      NSURLSessionConfiguration.defaultSessionConfiguration()
    }()

    public lazy var session: NSURLSession = {
      NSURLSession(configuration: self.configuration, delegate: self, delegateQueue: nil)
    }()

    public func build(app: App) -> Middleware {
      let middleware = Faraday.URLSession(app: app)
      middleware.session = session
      return middleware
    }

    // MARK: - URL Session Delegate

    // Finishes a response with an error, if and only if a final error
    // occurs. URL sessions complete either with or without an error. All data
    // has already been delivered at this point. The URL session adapter
    // delivers data and completion as separate events. Data does not arrive
    // with errors. Errors, if any, arrives on completion after data. The
    // implementation ignores completion when no error. If an error, the final
    // finish retains the status and headers, but has no body.
    public func URLSession(session: NSURLSession,
                           task: NSURLSessionTask,
                           didCompleteWithError error: NSError?) {
      guard let env = task.env else {
        return
      }
      task.env = nil
      guard let response = env.response,
            let error = error else {
        return
      }
      env.error = error
      response.body = nil
      response.finish(env)
    }

    // MARK: - URL Session Data Delegate

    // Handles data-received events for both data and upload tasks; an upload
    // task _is_ a data task because data task is upload task's super-class. The
    // Handler consumes data as the URL session delegate.
    //
    // The data task sends either complete or partial data. How can you tell if
    // the data comprises the final response or whether the message is one of
    // many continuing responses in a multipart sequence? Multi-part responses
    // see an initial finished response followed by additional finished
    // responses until either the end-point terminates the connection or the
    // client cancels the response.
    //
    // Cancels the data task if the environment has no response. This only
    // happens if a completion handler disconnects the response because it wants
    // no more information.
    public func URLSession(session: NSURLSession,
                           dataTask: NSURLSessionDataTask,
                           didReceiveData data: NSData) {
      guard let env = dataTask.env else {
        return
      }
      guard let _ = env.response else {
        dataTask.cancel()
        return
      }
      guard let HTTPURLResponse = dataTask.response as? NSHTTPURLResponse else {
        return
      }
      let status = HTTPURLResponse.statusCode
      var headers = Headers()
      for (key, value) in HTTPURLResponse.allHeaderFields {
        headers[String(key)] = String(value)
      }
      env.saveResponse(status, body: data, headers: headers)
    }

  }

}

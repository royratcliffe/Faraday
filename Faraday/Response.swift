// Faraday Response.swift
//
// Copyright © 2015, Roy Ratcliffe, Pioneering Software, United Kingdom
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

public class Response {

  public init() {}

  /// - returns: Answers the response status as an integer. Answers `nil` if
  ///   there is no status as yet.
  public var status: Int?

  public var headers = Headers()

  public var body: Body?

  var env: Env?

  /// - returns: true if the response status is successful. Only answers success
  ///   if the response has finished. Success means any status between 200 and
  ///   299. Answers false if the response status does not lie in the success
  ///   range, or there is no status because the response is not yet
  ///   finished. Success therefore also implies finished.
  public var success: Bool {
    guard let status = status where finished else {
      return false
    }
    return (200..<300).contains(status)
  }

  var finished: Bool {
    return env != nil
  }

  // MARK: - On Complete

  public typealias OnCompleteCallback = (Env) -> Void

  public var onCompleteCallbacks = [OnCompleteCallback]()

  public func onComplete(callback: OnCompleteCallback) -> Response {
    onCompleteCallbacks.append(callback)
    return self
  }

  /// Adds a response completion call-back to the end of the call-backs just as
  /// onComplete does, but asynchronously runs the given capture in the given
  /// dispatch queue. Useful when the adapter finishes responses asynchronously
  /// in some other queue.
  public func onComplete(queue: dispatch_queue_t, callback: OnCompleteCallback) -> Response {
    return onComplete { env in
      dispatch_async(queue) {
        callback(env)
      }
    }
  }

  func finish(env: Env) -> Response {
    for callback in onCompleteCallbacks {
      callback(env)
    }
    self.env = env
    return self
  }

  // MARK: - Response Middleware

  public class Middleware: Faraday.Middleware {

    public override func call(env: Env) -> Response {
      return app(env).onComplete { env in
        self.onComplete(env)
      }
    }

    /// Override to modify the environment after the response has finished.
    public func onComplete(env: Env) {}

  }

}

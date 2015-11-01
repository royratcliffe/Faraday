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

  public var status: Int?

  public var headers = Headers()

  public var body: Body?

  // MARK: - Response Middleware

  public class Middleware: Faraday.Middleware {

    public override func call(env: Env) -> Response {
      return app(env).onComplete { env in
        self.onComplete(env)
      }
    }

    func onComplete(env: Env) {}

  }

  var env: Env?

  var finished: Bool {
    return env != nil
  }

  public typealias OnCompleteCallback = (Env) -> Void

  public var onCompleteCallbacks = [OnCompleteCallback]()

  public func onComplete(callback: OnCompleteCallback) -> Response {
    onCompleteCallbacks.append(callback)
    return self
  }

  func finish(env: Env) -> Response {
    for callback in onCompleteCallbacks {
      callback(env)
    }
    self.env = env
    return self
  }

}

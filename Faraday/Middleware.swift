// Faraday Middleware.swift
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

/// Middleware is a piece of software that sits on a stack waiting for requests
/// to handle. Rack builders construct the stack and connections invoke the
/// stack with a given request. Middleware handles the request in stack order,
/// first to last. The last piece of middleware handles the request, converting
/// it to a response which passes back up the stack of middleware. Response
/// middleware adds a completion handler to the unfinished response. Such
/// handlers run in reverse-stack order when the asynchronous response finishes.
public class Middleware {

  /// Retains the middleware application: simply just a capture that takes an
  /// environment and answers a response. Nothing more than that. Middleware is
  /// therefore just an object that retains such a capture. When you call the
  /// middleware, it merely invokes the capture and passes back the capture's
  /// response.
  public var app: App

  public required init(app: App) {
    self.app = app
  }

  /// The adapter lives at the deepest part of the middleware stack. It
  /// generates the response object which passes back up through the middleware
  /// call stack. This implies that the middleware sees the response in reverse
  /// order, deepest first. If middleware pieces want to handle the response in
  /// some way, they can add an on-complete handler. These push in the order
  /// given, i.e. in reverse middleware order. Hence, when the response finishes
  /// and runs the call-back handlers in forward order, first to last, then the
  /// actual order is reverse middleware, deep to shallow.
  ///
  /// Note that an adapter implementation of `call(app, env)` does _not_ call
  /// the `app` for the response. Instead, it constructs a new unfinished
  /// response and finishes that new response at some later point in time.
  public func call(env: Env) -> Response {
    return app(env)
  }

}

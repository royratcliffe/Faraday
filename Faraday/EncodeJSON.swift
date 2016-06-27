// Faraday EncodeJSON.swift
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

/// This is the simplest possible JSON encoder implementation. It delegates to
/// `super` if there is no request. That will never happen under normal
/// circumstances. If the request has a body, try to serialise it as JSON. If
/// serialisation succeeds, set up a new body and `Content-Type` header. The
/// new body becomes data after serialisation, an `NSData` object. The body
/// was previously anything that the JSON serialiser considers valid.
///
/// The implementation only sets up the content-type header for JSON if, and
/// only if, not already set. If the encoder finds no content-type, then it
/// becomes `application/json`.
public class EncodeJSON: Middleware {

  public override func call(env: Env) -> Response {
    guard let request = env.request else {
      return super.call(env: env)
    }
    guard let body = request.body where JSONSerialization.isValidJSONObject(body) else {
      return super.call(env: env)
    }
    if let data = try? JSONSerialization.data(withJSONObject: body, options: [.prettyPrinted]) {
      if request.headers["Content-Type"] == nil {
        request.headers["Content-Type"] = "application/json"
      }
      request.body = data
    }
    return app(env)
  }

  public class Handler: RackHandler {

    public init() {}

    public func build(app: App) -> Middleware {
      return EncodeJSON(app: app)
    }

  }

}

// Faraday DecodeJSON.swift
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

/// Response middleware for decoding JSON. If the response body is raw data, the
/// decoder attempts to convert the data to a JSON object. If successful, the
/// decoder replaces the data with the JSON object. The decoder allows JSON
/// fragments, primitives as well as objects and arrays. It does not test the
/// response's content type.
public class DecodeJSON: Response.Middleware {

  /// Sets up the request headers to accept JSON.
  public override func call(env: Env) -> Response {
    env.request?.accepts = ["application/json"]
    return super.call(env)
  }

  /// Parses the response for JSON. Converts an `NSData` object in the response
  /// body to an NSObject representing the JSON. It allows both JSON objects and
  /// JSON primitives.
  override func onComplete(env: Env) {
    guard let response = env.response else {
      return super.onComplete(env)
    }
    if let data = response.body as? NSData {
      if let object = try? NSJSONSerialization.JSONObjectWithData(data, options: [.AllowFragments]) {
        response.body = object
      }
    }
  }

  public class Handler: RackHandler {

    public init() {}

    public func build(app: App) -> Middleware {
      return DecodeJSON(app: app)
    }

  }

}

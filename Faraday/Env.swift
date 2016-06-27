// Faraday Env.swift
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

/// The environment is a bag of key-value pairs collating information about the
/// state of the request and the response, a scratchpad for the request-response
/// cycle. (The Faraday implementation in Ruby is a dictionary of strings to any
/// objects. Values have any type but indexed by known strings.) In Swift, the
/// environment here is just a request-response pair for carrying
/// request-response state. The environment starts off unfinished. Middleware
/// request handlers load the environment; then later, the middleware
/// responder-chain loads the response. In-between an adapter fires off the
/// request and captures the raw response when it arrives.
public class Env {

  public init() {}

  public var request: Request?

  public var response: Response?

  public var error: ErrorProtocol?

  /// Saves and finishes the response. Called by the adapter when the response
  /// finally arrives.
  public func saveResponse(status: Int, body: Body?, headers: Headers) {
    guard let response = response else {
      return
    }
    response.status = status
    response.body = body
    response.headers = headers
    let _ = response.finish(env: self)
  }

  /// Cancels the response. Requires that the response object exists. Otherwise
  /// cancels nothing. Response objects begin to exist when the Rack builder
  /// hits the bottom of the middleware stack.
  public func cancel() {
    response?.cancel()
  }

}

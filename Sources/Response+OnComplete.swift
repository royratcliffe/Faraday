// Faraday Response+OnComplete.swift
//
// Copyright © 2016, Roy Ratcliffe, Pioneering Software, United Kingdom
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

extension Response {

  /// Runs the given completion call-back when the response answers with a
  /// successful status, where success means a response status code within the
  /// integer range 200 and 299 inclusive.
  public func onSuccess(callback: @escaping OnCompleteCallback) -> Response {
    return onComplete { env in
      guard let response = env.response else {
        return
      }
      if response.success {
        callback(env)
      }
    }
  }

  /// Runs a call-back when the response fails, where failure means *not* a
  /// status between 200 and 299. Failure does not include a non-status
  /// response, a response where there is no status or nil-status. This
  /// possibility exists logically, although not so in practice since the
  /// completion call-backs only execute when the response finishes. Finishing
  /// happens when the middleware adapter saves the response, supplying a
  /// non-optional status code. This code becomes the response status.
  public func onFailure(callback: @escaping OnCompleteCallback) -> Response {
    return onComplete { env in
      guard let response = env.response else {
        return
      }
      if !response.success {
        callback(env)
      }
    }
  }

}

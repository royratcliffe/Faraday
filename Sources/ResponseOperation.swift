// Faraday ResponseOperation.swift
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

/// Waits for a response. Finishes an operation when either the response
/// completes, or optionally when an independent timeout expires. The timeout
/// runs concurrently with any connection timeout.
///
/// Works by inserting a semaphore between the response completion handlers and
/// the operation. Note, the operation does nothing and returns immediately if
/// cancelled.
public class ResponseOperation: Operation {

  /// Response to finish the operation whenever the response completes, either
  /// completing successfully or with failure.
  public var response: Response!

  /// Optional timeout interval in seconds. There is no default timeout
  /// interval. The operation waits forever for the response to complete, by
  /// default.
  public var timeoutInterval: TimeInterval?

  /// - returns: True if the operation timed out while waiting for the response
  ///   to complete. Answers `false` when the response finishes in time, or
  ///   `nil` until the operation finishes.
  public private(set) var timedOut: Bool?

  /// Conveniently initialises an operation using a given response.
  public convenience init(_ response: Response) {
    self.init()
    self.response = response
  }

  //----------------------------------------------------------------------------
  // MARK: - NSOperation Overrides

  public override func main() {
    // Do nothing and return immediately if cancelled.
    guard !isCancelled else {
      return
    }

    // Wait for the response to complete, successfully or otherwise.
    let semaphore = DispatchSemaphore(value: 0)
    response.onComplete { (env) in
      semaphore.signal()
    }
    if let timeoutInterval = timeoutInterval {
      timedOut = semaphore.wait(timeout: .now() + timeoutInterval) != .timedOut
    } else {
      semaphore.wait()
      timedOut = false
    }
  }

}

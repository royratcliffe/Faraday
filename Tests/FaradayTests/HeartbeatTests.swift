// FaradayTests HeartbeatTests.swift
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

import XCTest
import Faraday

class HeartbeatTests: XCTestCase {

  let connection = Connection()

  override func setUp() {
    super.setUp()

    connection.url = URL(string: "http://heartbeatapi.herokuapp.com/")
    connection.use(handler: EncodeJSON.Handler())
    connection.use(handler: DecodeJSON.Handler())
    connection.use(handler: Logger.Handler())
    connection.use(handler: URLSessionAdapter.Handler())
  }

  func testInterval() {
    // given
    let expectation = self.expectation(description: "Interval")

    // when
    _ = connection.get(path: ".") { request in
      request.setQuery(values: ["1.1"], forName: "interval")
    }.onComplete { env in
      guard let response = env.response else {
        return
      }
      let body = response.body as? NSDictionary
      XCTAssertNotNil(env.response)
      XCTAssertNotNil(response.body)
      XCTAssertNotNil(body)
      XCTAssertEqual(env.response?.status, 200)
      XCTAssertNotNil(body?["date"])
      XCTAssertNotNil(body?["count"])
      if let count = body?["count"] as? Int, count >= 3 {
        expectation.fulfill()
        // Do not send `XCTestExpectation.fulfill()` more than once. Doing so
        // triggers a `NSInternalInconsistencyException` error. Multiple fulfil
        // messages amounts to an API violation. Avoid this by terminating the
        // request. Terminate by disconnecting the environment from the
        // response. The completion handler will see no more responses.
        env.response = nil
      }
    }

    // then
    waitForExpectations(timeout: 60.0) { (error) -> Void in
      if let error = error {
        NSLog("%@", error.localizedDescription)
      }
      XCTAssertNil(error)
    }
  }

  func testLimit() {
    // given
    let limitExpectation = expectation(description: "Limit")
    let errorExpectation = expectation(description: "Error")

    // when
    _ = connection.get { request in
      request.setQuery(values: ["10"], forName: "limit")
    }.onComplete { env in
      guard env.error == nil else {
        if let error = env.error as? NSError {
          XCTAssertEqual(error.domain, NSURLErrorDomain)
          XCTAssertEqual(error.code, NSURLErrorCancelled)
          XCTAssertTrue(error.isURLCancelled)
        }
        XCTAssertNil(env.response?.body)
        errorExpectation.fulfill()
        return
      }
      guard let response = env.response else {
        return
      }
      let body = response.body as? NSDictionary
      XCTAssertNotNil(env.response)
      XCTAssertNotNil(response.body)
      XCTAssertNotNil(body)
      XCTAssertEqual(env.response?.status, 200)
      XCTAssertNotNil(body?["date"])
      XCTAssertNotNil(body?["count"])
      if let count = body?["count"] as? Int, count == 10 {
        limitExpectation.fulfill()
        // Sending a `cancel()` message differs from setting `response` to `nil`
        // when using the URL session adapter. It triggers a final nil-body
        // response with a cancel error.
        //
        //        env.response = nil
        //
        env.cancel()
      }
    }

    // then
    waitForExpectations(timeout: 60.0) { (error) -> Void in
      if let error = error {
        NSLog("%@", error.localizedDescription)
      }
      XCTAssertNil(error)
    }
  }

}

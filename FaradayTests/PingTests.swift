// FaradayTests PingTests.swift
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

import XCTest
import Faraday

class PingTests: ConnectionTests {

  func testGet() {
    // given
    let expectation = self.expectation(withDescription: "GET ping")

    // when
    let _ = connection.get(path: "ping").onComplete { env in
      guard let response = env.response else {
        return
      }
      let body = response.body as? NSDictionary
      XCTAssertNotNil(env.response)
      XCTAssertNotNil(response.body)
      XCTAssertNotNil(body)
      XCTAssertEqual(env.response?.status, 200)
      XCTAssertNotNil(body?["now"])
      expectation.fulfill()
    }

    // then
    waitForExpectations(withTimeout: 60.0) { error in
      XCTAssertNil(error)
    }
  }

  class Counter {

    var count = 0
    let limit: Int

    let connection: Connection

    typealias CompletionHandler = (Counter) -> Void
    let completionHandler: CompletionHandler?

    init(limit: Int, connection: Connection, completionHandler: CompletionHandler? = nil) {
      self.connection = connection
      self.limit = limit
      self.completionHandler = completionHandler
    }

    func ping() {
      let _ = self.connection.get(path: "ping").onComplete { env in
        self.pong()
      }
    }

    func pong() {
      count += 1
      if count == limit {
        completionHandler?(self)
      } else {
        ping()
      }
    }

  }

  /// Performs three GET requests in a row, one after the other.
  ///
  /// Weakly retains the expectation in order to avoid unnecessary exceptions
  /// when trying to fulfil an expectation for which the time-out has already
  /// expired.
  ///
  /// Give Heroku at least 60 seconds to spin up a free dyno.
  func testCounter() {
    // given
    let expectation = self.expectation(withDescription: "Counter")
    // when
    let counter = Counter(limit: 3, connection: connection) { [weak expectation] counter in
      expectation?.fulfill()
    }
    counter.ping()
    // then
    waitForExpectations(withTimeout: 60.0) { (error) -> Void in
      XCTAssertNil(error)
    }
  }

  func testPost() {
    // given
    let expectation = self.expectation(withDescription: "POST ping")

    // when
    let response = connection.post { request in
      request.path = "ping"
      request.body = ["ping": "pong"]
      var urlComponents = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)
      urlComponents?.setQuery(values: ["world"], forName: "hello")
      request.url = urlComponents?.url(relativeTo: request.url?.baseURL)
    }
    let _ = response.onComplete { env in
      let body = response.body as? NSDictionary
      XCTAssertNotNil(env.response)
      XCTAssertNotNil(response.body)
      XCTAssertNotNil(body)
      XCTAssertEqual(env.response?.status, 201)
      XCTAssertNotNil(body?["ping"])
      XCTAssertEqual(body?["ping"] as? String, "pong")
      expectation.fulfill()
    }

    // then
    waitForExpectations(withTimeout: 60.0) { error in
      XCTAssertNil(error)
    }
  }

}

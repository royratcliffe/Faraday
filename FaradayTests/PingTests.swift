// FaradayTests PingTests.swift
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

import XCTest

class PingTests: ConnectionTests {

  func testGet() {
    // given
    let expectation = expectationWithDescription("GET ping")

    // when
    let response = connection.get { request in
      request.path = "ping"
    }
    response.onComplete { env in
      let body = response.body as? NSDictionary
      XCTAssertNotNil(env.response)
      XCTAssertNotNil(response.body)
      XCTAssertNotNil(body)
      XCTAssertEqual(env.response?.status, 200)
      XCTAssertNotNil(body?["now"])
      expectation.fulfill()
    }

    // then
    waitForExpectationsWithTimeout(30.0) { error in
      XCTAssertNil(error)
    }
  }

  func testPost() {
    // given
    let expectation = expectationWithDescription("POST ping")

    // when
    let response = connection.post { request in
      request.path = "ping"
      request.body = ["ping": "pong"]
      let URLComponents = NSURLComponents(URL: request.URL!, resolvingAgainstBaseURL: false)
      URLComponents?.setQueryValues(["world"], forName: "hello")
      request.URL = URLComponents?.URLRelativeToURL(request.URL?.baseURL)
    }
    response.onComplete { env in
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
    waitForExpectationsWithTimeout(30.0) { error in
      XCTAssertNil(error)
    }
  }

}

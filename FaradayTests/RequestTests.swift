// FaradayTests RequestTests.swift
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

class RequestTests: XCTestCase {

  // given
  let request = Request()
  let baseURL = NSURL(string: "http://localhost:9292/api/")

  func testNoBaseURL() {
    // when
    request.path = "path/to"
    // then
    XCTAssertNil(request.path)
  }

  func testEmptyRelativeToURL() {
    // when
    request.URL = NSURL(string: "", relativeToURL: baseURL)
    // then
    XCTAssertEqual(request.path, "")
    XCTAssertEqual(request.URL?.path, "/api")
  }

  func testPathToRelativeToURL() {
    // when
    request.URL = NSURL(string: "path/to", relativeToURL: baseURL)
    // then
    XCTAssertEqual(request.path, "path/to")
    XCTAssertEqual(request.URL?.path, "/api/path/to")
  }

  /// Setting the path sets the relative path, not the absolute path. The
  /// connection object does this kind of set up for new request URLs.
  func testPathSetter() {
    // given
    request.URL = NSURL(string: "", relativeToURL: baseURL)
    // when
    request.path = "path/to"
    // then
    XCTAssertEqual(request.path, "path/to")
    XCTAssertEqual(request.URL?.path, "/api/path/to")
  }

  func testPathComponentsSetter() {
    // given
    request.URL = NSURL(string: "", relativeToURL: baseURL)
    // when
    request.pathComponents = ["path", "to"]
    // then
    XCTAssertNotNil(request.pathComponents)
    XCTAssertEqual(request.pathComponents!, ["path", "to"])
    // and then
    XCTAssertEqual(request.path, "path/to")
    XCTAssertEqual(request.URL?.path, "/api/path/to")
  }

  func testAccepts() {
    // given
    request.accepts = ["application/hal+json; q=1.0", "text/plain"]
    // when
    let accept = request.accept
    // then
    XCTAssertEqual(accept, "application/hal+json; q=1.0, text/plain")
    XCTAssertEqual(request.accepts!, ["application/hal+json; q=1.0", "text/plain"])
  }

}

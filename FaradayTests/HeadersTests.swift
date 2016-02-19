// FaradayTests HeadersTests.swift
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

class HeadersTests: XCTestCase {

  func testGetterSetter() {
    // given
    let headers = Headers()
    // when
    headers["Content-Length"] = "0"
    // then
    XCTAssertEqual(headers["Content-Length"], "0")
  }

  func testAcceptsEmpty() {
    // given
    let headers = Headers()
    // when
    headers.accepts([])
    // then
    XCTAssertNotNil(headers.accept)
    XCTAssertEqual(headers.accepts!, [])
  }

  func testAcceptsNonEmpty() {
    // given
    let headers = Headers()
    // when
    headers.accepts(["application/json"])
    // then
    XCTAssertNotNil(headers.accept)
    XCTAssertEqual(headers.accept, "application/json")
  }

  func testAcceptsDuplicate() {
    // given
    let headers = Headers()
    // when
    headers.accepts(["application/json"])
    headers.accepts(["application/json"])
    // then
    XCTAssertNotNil(headers.accept)
    XCTAssertEqual(headers.accept, "application/json")
  }

  func testGenerate() {
    // given
    let headers = Headers()
    headers["Content-Length"] = "\(0)"
    // when
    var headerFields = [String: String]()
    headers.forEach { field, value in
      headerFields[field] = value
    }
    // then
    XCTAssertEqual(headerFields["Content-Length"], "\(0)")
  }

  func testBasicAuth() {
    // given
    let headers = Headers()
    // when
    headers.basicAuth("login", pass: "pass")
    // then
    XCTAssertEqual(headers.authorization, "Basic bG9naW46cGFzcw==")
  }

  func testTokenAuth() {
    // given
    let headers = Headers()
    // when
    headers.tokenAuth("abcdef", options: ["foo": "bar"])
    // then
    XCTAssertTrue(["Token token=abcdef,foo=bar", "Token foo=bar,token=abcdef"].contains(headers.authorization!))
  }

}

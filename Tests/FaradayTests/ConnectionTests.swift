// FaradayTests ConnectionTests.swift
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

class ConnectionTests: XCTestCase {

  let connection = Connection()

  /// Builds a logged JSON-based connection using Apple's `URLSession`
  /// adapter. Requests first see the encode-JSON handler which encodes the
  /// request body using JSON serialisation, from a dictionary to a JSON-encoded
  /// string. Then the JSON-decoder sees the request but does nothing; the
  /// decoder only handles the response when it arrives. Next, the logger
  /// handler sees the request and dumps its details to the debug console using
  /// `NSLog`. Finally, the URL session adapter sees the request and runs it.
  ///
  /// When the response arrives, the response body and headers pass back _up_
  /// through the middleware stack. The logger logs the response. The decoder
  /// converts the response body from JSON to a dictionary. Finally, the encoder
  /// sees the response and does nothing because it only cares about the
  /// request. The outcome arrives with the `Response` object, asynchronously.
  override func setUp() {
    super.setUp()

    // The URL's trailing slash is very important. Without it, merging URLs will
    // replace the entire path rather than just append the path.
    connection.url = URL(string: "http://faraday-tests.herokuapp.com/")
    connection.use(handler: EncodeJSON.Handler())
    connection.use(handler: DecodeJSON.Handler())
    connection.use(handler: Logger.Handler())
    connection.use(handler: URLSessionAdapter.Handler())
  }

}
